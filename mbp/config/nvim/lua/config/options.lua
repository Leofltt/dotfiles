-- Core Neovim options and globals

-- tslime.vim
vim.g.tslime_always_current_session = 1

-- Disable netrw (using nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Python host
vim.g.python3_host_prog = "/opt/homebrew/bin/python3"

-- GUI font
vim.o.guifont = "JetBrainsMono Nerd Font Mono"

local opt = vim.opt

-- UI & appearance
opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.winborder = "rounded"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Scrolling & wrapping
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Code folding (upgraded to Treesitter / LSP expr folding in autocmds.lua)
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldcolumn = "0"
opt.foldtext = ""
opt.fillchars:append({ fold = " " })

-- Persistent undo
opt.undofile = true
local undo_dir = vim.fn.stdpath("data") .. "/undodir"
opt.undodir = undo_dir
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

-- Responsiveness & completion
opt.autoread = true
opt.updatetime = 300
opt.timeoutlen = 300
opt.completeopt = { "menu", "menuone", "noselect" }

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    source = "if_many",
  },
  float = {
    border = "rounded",
    source = "if_many",
  },
})
