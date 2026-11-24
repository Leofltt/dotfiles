-- Autocommands (Treesitter highlight, yank highlight, split resize, LSP attach)

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("UserHighlightYank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
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

-- Native Neovim 0.12 Treesitter highlighting (falls back to Vim syntax when queries are missing)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match)
    if lang and vim.treesitter.query.get(lang, "highlights") then
      pcall(vim.treesitter.start, ev.buf, lang)
    end
  end,
})

-- Buffer-local LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
    local map = vim.keymap.set
    local function bopts(desc)
      return { buffer = ev.buf, noremap = true, silent = true, desc = desc }
    end

    map("n", "gD", vim.lsp.buf.declaration, bopts("Goto declaration"))
    map("n", "gd", vim.lsp.buf.definition, bopts("Goto definition"))
    map("n", "K", vim.lsp.buf.hover, bopts("Hover documentation"))
    map("n", "gi", vim.lsp.buf.implementation, bopts("Goto implementation"))
    map("n", "<leader>k", vim.lsp.buf.signature_help, bopts("Signature help"))
    map("i", "<C-k>", vim.lsp.buf.signature_help, bopts("Signature help"))
    map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bopts("Add workspace folder"))
    map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bopts("Remove workspace folder"))
    map("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bopts("List workspace folders"))
    map("n", "<leader>D", vim.lsp.buf.type_definition, bopts("Goto type definition"))
    map("n", "<leader>rn", vim.lsp.buf.rename, bopts("Rename symbol"))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, bopts("Code action"))
    map("n", "gr", vim.lsp.buf.references, bopts("Goto references"))

    map({ "n", "v" }, "<leader>f", function()
      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ bufnr = ev.buf, async = true, lsp_format = "fallback" })
      else
        vim.lsp.buf.format({ async = true })
      end
    end, bopts("Format buffer"))

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
