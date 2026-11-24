-- General keymaps (plugin-specific maps live in their plugin specs or LspAttach)

local map = vim.keymap.set
local gopts = { noremap = true, silent = true }

-- File & search convenience
map("n", "<leader>wq", ":q<CR>", vim.tbl_extend("force", gopts, { desc = "Quit window" }))
map("n", "<leader>ww", ":w<CR>", vim.tbl_extend("force", gopts, { desc = "Write buffer" }))
map("n", "<leader><space>", ":nohlsearch<CR>", vim.tbl_extend("force", gopts, { desc = "Clear search highlight" }))

-- macOS Command shortcuts (GUI / extended-key terminals)
map("n", "<D-a>", "ggVG", { noremap = true, desc = "Select All" })
map("v", "<D-c>", '"+y', { noremap = true, desc = "Copy to system clipboard" })
map("n", "<D-/>", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<D-/>", "gc", { remap = true, desc = "Toggle comment selection" })

-- Tslime (send to tmux)
map("v", "<leader>cc", "<Plug>SendSelectionToTmux", vim.tbl_extend("force", gopts, { desc = "Send selection to tmux" }))
map("n", "<leader>cc", "<Plug>NormalModeSendToTmux", vim.tbl_extend("force", gopts, { desc = "Send line to tmux" }))
map("n", "<leader>cr", "<Plug>SetTmuxVars", vim.tbl_extend("force", gopts, { desc = "Set tmux target" }))

-- Remove Neovim 0.11+ default gr* LSP maps so buffer-local `gr` fires immediately
for _, lhs in ipairs({ "gra", "gri", "grn", "grr", "grt" }) do
  pcall(vim.keymap.del, "n", lhs)
end
pcall(vim.keymap.del, "x", "gra")

-- Diagnostics & formatting toggle
map("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic loclist" })
map({ "n", "v" }, "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_format = "fallback" })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Format buffer / selection" })
map("n", "<leader>uf", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify("Format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end, { desc = "Toggle format on save" })
