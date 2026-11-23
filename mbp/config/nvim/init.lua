-- ~/.config/nvim/init.lua
-- Set leader keys before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")

local ok, _ = pcall(vim.cmd.colorscheme, "leofltt-monoish")
if not ok then
  vim.notify("Colorscheme 'leofltt-monoish' not found.", vim.log.levels.WARN)
end
