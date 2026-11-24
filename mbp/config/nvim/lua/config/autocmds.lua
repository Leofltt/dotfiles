-- Autocommands (Treesitter highlight, yank highlight, split resize, LSP attach)

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserHighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Auto-reload buffers edited externally (e.g. by AI CLI agents in Neovim splits or tmux)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("UserAutoRead", { clear = true }),
  callback = function()
    if vim.fn.mode() ~= "c" then
      pcall(vim.cmd, "checktime")
    end
  end,
})

-- Equalize splits when terminal window resizes
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("UserResizeSplits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Native Neovim 0.12 Treesitter highlighting & folding (falls back to Vim syntax / indent folding when queries are missing)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and vim.treesitter.query.get(lang, "highlights") then
      local ok_ts = pcall(vim.treesitter.start, ev.buf, lang)
      if ok_ts and vim.treesitter.query.get(lang, "folds") then
        for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
          vim.wo[win].foldmethod = "expr"
          vim.wo[win].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end
    end
  end,
})

-- Buffer-local LSP keymaps & folding fallback on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/foldingRange") then
      for _, win in ipairs(vim.fn.win_findbuf(ev.buf)) do
        if vim.wo[win].foldmethod ~= "expr" then
          vim.wo[win].foldmethod = "expr"
          vim.wo[win].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
      end
    end

    local map = vim.keymap.set
    local function bopts(desc)
      return { buffer = ev.buf, noremap = true, silent = true, desc = desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, bopts("Goto declaration"))
    map("n", "gd", vim.lsp.buf.definition, bopts("Goto definition"))
    map("n", "K", vim.lsp.buf.hover, bopts("Hover documentation"))
    map("n", "gi", vim.lsp.buf.implementation, bopts("Goto implementation"))
    map("n", "<leader>k", vim.lsp.buf.signature_help, bopts("Signature help"))
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bopts("Add workspace folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bopts("Remove workspace folder"))
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bopts("List workspace folders"))
    map("n", "<leader>D", vim.lsp.buf.type_definition, bopts("Goto type definition"))
    map("n", "<leader>rn", vim.lsp.buf.rename, bopts("Rename symbol"))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bopts("Code action"))
    map("n", "gr", function()
      local ok, builtin = pcall(require, "telescope.builtin")
      if ok then
        builtin.lsp_references()
      else
        vim.lsp.buf.references()
      end
    end, bopts("Goto references"))

    map("n", "<leader>uh", function()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = ev.buf })
    end, bopts("Toggle inlay hints"))

    map("n", "<leader>ds", function()
      local ok, builtin = pcall(require, "telescope.builtin")
      if ok then
        builtin.lsp_document_symbols()
      end
    end, bopts("Document symbols"))

    map("n", "<leader>ws", function()
      local ok, builtin = pcall(require, "telescope.builtin")
      if ok then
        builtin.lsp_dynamic_workspace_symbols()
      end
    end, bopts("Workspace symbols"))
  end,
})
