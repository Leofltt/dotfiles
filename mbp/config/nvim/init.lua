-- ~/.config/nvim/init.lua
--[[

Sections:
1. lazy.nvim Bootstrap
2. Global Settings (vim.g)
3. Neovim Options (vim.opt)
4. lazy.nvim Plugin Setup & Configuration
   - Core/UI (lazy, telescope, nvim-tree)
   - AI (CodeCompanion, Tabby) -- CORRECTED
   - Git (fugitive)
   - Completion (cmp, luasnip)
   - LSP (lspconfig, mason)
   - Utility (treesitter, fzf, tslime, rspec, emmet, Comment)
   - Csound
5. General Key Mappings
6. Autocmds
7. Colorscheme Loading -- CORRECTED

--]]

-- -----------------------------------------------------------------------------
-- 1. lazy.nvim Bootstrap
-- -----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- -----------------------------------------------------------------------------
-- 2. Global Settings (vim.g)
-- -----------------------------------------------------------------------------
vim.g.mapleader = ' '      -- Set leader key to Space
vim.g.maplocalleader = ' ' -- Set localleader key to Space

-- For tslime.vim
vim.g.tslime_always_current_session = 1

-- Disable default providers
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.python3_host_prog = '/opt/homebrew/bin/python3'

-- font
vim.o.guifont = "JetBrainsMono Nerd Font Mono"

-- -----------------------------------------------------------------------------
-- 3. Neovim Options (vim.opt)
-- -----------------------------------------------------------------------------
local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true

opt.undofile = true
local undo_dir = vim.fn.stdpath("data") .. "/undodir"
opt.undodir = undo_dir
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

opt.updatetime = 300
opt.signcolumn = "yes"
opt.completeopt = { "menu", "menuone", "noselect" }

-- -----------------------------------------------------------------------------
-- 4. lazy.nvim Plugin Setup & Configuration
-- -----------------------------------------------------------------------------
require("lazy").setup({
  -- == Core / UI ==
  { "nvim-lua/plenary.nvim" }, -- Utility functions, required by many plugins

  { -- Fuzzy Finder
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55 },
          },
          sorting_strategy = "ascending",
          winblend = 0,
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
      }
      local builtin = require('telescope.builtin')
      local map = vim.keymap.set
      map('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      map('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      map('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
      map('n', '<leader>fo', builtin.oldfiles, { desc = 'Find Old Files' })
      map('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })
    end
  },

  { -- File Explorer
    'nvim-tree/nvim-tree.lua',
    version = "*",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('nvim-tree').setup({
        sort_by = "case_sensitive",
        view = { width = 35, side = 'left', preserve_window_proportions = true },
        renderer = { group_empty = true, highlight_git = true, icons = { show = { file = true, folder = true, folder_arrow = true, git = true } } },
        filters = { dotfiles = false, custom = { ".git", "node_modules", ".cache", "__pycache__" } },
        git = { enable = true, ignore = false, timeout = 400 },
        actions = { open_file = { quit_on_open = false, resize_window = true } },
        hijack_directories = { enable = true, auto_open = true },
        update_focused_file = { enable = true, update_root = false },
      })
      local map = vim.keymap.set
      map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer' })
      map('n', '<leader>o', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle NvimTree & Find File' })
    end,
  },

  -- == AI Plugins ==

  { -- Interactive AI Companion
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("codecompanion").setup({
        -- CORRECTED: Set 'ollama' as the default adapter for all actions.
        adapter = "ollama",
        
        adapters = {
          http = {
            ollama = {
              -- Options for the ollama adapter go directly here
              model = "codellama:13b", -- IMPORTANT: Change to a model you have in Ollama
              -- host = "http://192.168.1.100:11434", -- Uncomment if Ollama is not on localhost
            },
          },
        },

        -- This section is now optional if you only use the default adapter,
        -- but we'll leave it for clarity. It will use the 'ollama'
        -- adapter defined above.
        strategies = {
          chat = { adapter = "ollama" },
          inline = { adapter = "ollama" },
          agent = { adapter = "ollama" },
        },
      })
    end,
  },

  { 
    "TabbyML/vim-tabby"
  },

  -- == Git ==
  { 'tpope/vim-fugitive' },

  -- == Completion ==
  { -- Autocompletion Engine
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'rafamadriz/friendly-snippets',
      -- REMOVED: cmp-tabby is no longer needed; it's built into vim-tabby
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        -- The source name 'tabby' is correct and provided by vim-tabby
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'tabby' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Setup nvim-cmp for command line
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = 'buffer' } }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
      })
    end
  },
  { 'L3MON4D3/LuaSnip' }, -- Snippet engine dependency

  -- == LSP (Language Server Protocol) ==
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local mason_lspconfig = require('mason-lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls", "pyright", "bashls", "dockerls", "jsonls", "yamlls",
          "rust_analyzer", "hls", "clangd",
        },
        handlers = {
          function(server_name) -- Default handler
            lspconfig[server_name].setup { capabilities = capabilities }
          end,
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup {
              capabilities = capabilities,
              settings = {
                Lua = {
                  runtime = { version = 'LuaJIT' },
                  diagnostics = { globals = { 'vim' } },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                  telemetry = { enable = false },
                },
              },
            }
          end,
          ["pyright"] = function() lspconfig.pyright.setup { capabilities = capabilities } end,
          ["rust_analyzer"] = function() lspconfig.rust_analyzer.setup { capabilities = capabilities, settings = { ["rust-analyzer"] = {} } } end,
          ["hls"] = function() lspconfig.hls.setup { capabilities = capabilities, settings = { haskell = {} } } end,
          ["clangd"] = function() lspconfig.clangd.setup { capabilities = capabilities } end,
        }
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
          local map = vim.keymap.set
          local opts = { buffer = ev.buf, noremap = true, silent = true }
          map('n', 'gD', vim.lsp.buf.declaration, opts)
          map('n', 'gd', vim.lsp.buf.definition, opts)
          map('n', 'K', vim.lsp.buf.hover, opts)
          map('n', 'gi', vim.lsp.buf.implementation, opts)
          map('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
          map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
          map('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
          map('n', '<leader>D', vim.lsp.buf.type_definition, opts)
          map('n', '<leader>rn', vim.lsp.buf.rename, opts)
          map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
          map('n', 'gr', vim.lsp.buf.references, opts)
          map('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
        end
      })
    end,
  },

  -- == Utility & Other ==
  {
    "nvim-treesitter/nvim-treesitter",
    build = function() require("nvim-treesitter.install").update({ with_sync = true })() end,
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "query", "bash", "c", "cpp", "go", "html",
          "css", "javascript", "typescript", "json", "yaml", "markdown",
          "markdown_inline", "python", "rust", "java", "haskell",
        },
        sync_install = false,
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  { 'junegunn/fzf', build = './install --all' },
  { 'junegunn/fzf.vim', dependencies = { 'junegunn/fzf' } },
  { 'jgdavey/tslime.vim' },
  { 'thoughtbot/vim-rspec' },
  { 'mattn/emmet-vim' },
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },

  -- == Csound Plugins ==
  { "luisjure/csound-vim", ft = { "csound", "csd" } },
  {
    "kunstmusik/csound-repl",
    ft = { "csound", "csd" },
    config = function()
      vim.g.csound_repl_target = "tmux"
      vim.api.nvim_create_augroup("CsoundReplPortConfig", { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = "CsoundReplPortConfig",
        pattern = "*.csd,*.csound",
        callback = function()
          if vim.fn.exists("Csound_set_port") == 1 then
            vim.cmd("call Csound_set_port(11000)")
          end
        end,
        once = true,
      })
    end,
  },

}, {
  checker = { enabled = true },
})

-- -----------------------------------------------------------------------------
-- 5. General Key Mappings
-- -----------------------------------------------------------------------------
local map = vim.keymap.set
local gopts = { noremap = true, silent = true }

-- AI Assistant Mappings
map({ 'n', 'v' }, '<leader>aa', function() require("codecompanion").actions() end, { desc = "AI Actions" })
map('n', '<leader>ac', function() require("codecompanion").chat() end, { desc = "AI Chat" })
map({ 'n', 'v' }, '<leader>ai', function() require("codecompanion").inline() end, { desc = "AI Inline" })

-- Tslime Mappings
map('v', '<leader>cc', '<Plug>SendSelectionToTmux', gopts)
map('n', '<leader>cc', '<Plug>NormalModeSendToTmux', gopts)
map('n', '<leader>cr', '<Plug>SetTmuxVars', gopts)

-- Basic Navigation and Window Management
map('n', '<C-h>', '<C-w>h', gopts)
map('n', '<C-j>', '<C-w>j', gopts)
map('n', '<C-k>', '<C-w>k', gopts)
map('n', '<C-l>', '<C-w>l', gopts)
map('n', '<leader>wq', ':q<CR>', gopts)
map('n', '<leader>ww', ':w<CR>', gopts)

-- Clear search highlight
map('n', '<leader><space>', ':nohlsearch<CR>', gopts)

-- System Clipboard & Commenting
map('n', '<D-a>', 'ggVG', { noremap = true, desc = "Select All" })
map('v', '<D-c>', '"+y', { noremap = true, desc = "Copy to system clipboard" })
map('n', '<D-/>', function() require('Comment.api').toggle.linewise.current() end, { desc = "Toggle comment" })
map('v', '<D-/>', '<ESC><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', { desc = "Toggle comment selection" })

-- -----------------------------------------------------------------------------
-- 6. Autocmds
-- -----------------------------------------------------------------------------
-- (Your autocmds here)

-- -----------------------------------------------------------------------------
-- 7. Colorscheme Loading
-- -----------------------------------------------------------------------------
-- REMOVED the plugin entry and reverted to your original loading method
local status_ok, _ = pcall(vim.cmd, 'colorscheme leofltt-monoish')
if not status_ok then
  print("Colorscheme 'leofltt-monoish' not found. Please install it or check the name.")
end
