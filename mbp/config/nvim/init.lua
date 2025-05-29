-- ~/.config/nvim/init.lua
--[[

Migrated from init.vim and updated with Lua plugins.

Sections:
1. lazy.nvim Bootstrap
2. Global Settings (vim.g)
3. Neovim Options (vim.opt)
4. lazy.nvim Plugin Setup & Configuration
   - Core/UI (lazy, telescope, colorscheme)
   - Git (fugitive)
   - Completion (cmp, luasnip)
   - LSP (lspconfig, mason)
   - Utility (fzf, tslime, rspec, emmet)
5. General Key Mappings
6. Autocmds (if any needed later)
7. Colorscheme Loading

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
-- For tslime.vim
vim.g.tslime_always_current_session = 1
-- vim.g.tslime_always_current_window = 1 -- This was commented out

-- Disable default providers loaded by Neovim (we might handle Python/Node via Mason)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.python3_host_prog = '/usr/bin/python3' -- Adjust if your python path is different


-- font
vim.o.guifont = "JetBrainsMono Nerd Font Mono"

-- -----------------------------------------------------------------------------
-- 3. Neovim Options (vim.opt)
--    Set common Neovim options
-- -----------------------------------------------------------------------------
local opt = vim.opt -- Alias for vim.opt

-- opt.nocompatible = false        -- This line is unnecessary and causes an error in modern Neovim
opt.number = true         -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true     -- Highlight the current line
opt.termguicolors = true  -- Enable true color support
opt.background = "dark"   -- Assume a dark background (important for colorschemes)

opt.expandtab = true      -- Use spaces instead of tabs
opt.shiftwidth = 2        -- Number of spaces to use for autoindent
opt.tabstop = 2           -- Number of spaces a <Tab> counts for
opt.softtabstop = 2       -- Number of spaces <Tab> counts for editing operations
opt.smartindent = true    -- Be smart about indentation

opt.ignorecase = true     -- Ignore case when searching
opt.smartcase = true      -- Override ignorecase if search pattern has uppercase letters
opt.hlsearch = true       -- Highlight search results
opt.incsearch = true      -- Show matches incrementally while typing

opt.scrolloff = 8         -- Keep 8 lines visible above/below cursor when scrolling
opt.sidescrolloff = 8     -- Keep 8 columns visible left/right of cursor
opt.wrap = false          -- Do not wrap long lines

-- Persistent Undo Setup
opt.undofile = true                                   -- Enable persistent undo
local undo_dir = vim.fn.stdpath("data") .. "/undodir" -- Store the path in a variable
opt.undodir = undo_dir                                -- Set the option using the variable
-- Check and create the directory using the variable directly
if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")   -- Create directory if it doesn't exist
end

opt.updatetime = 300                                -- Faster update time for CursorHold events (useful for LSP/git signs)
opt.signcolumn = "yes"                              -- Always show the sign column to avoid layout shifts

opt.completeopt = { "menu", "menuone", "noselect" } -- Completion options

-- -----------------------------------------------------------------------------
-- 4. lazy.nvim Plugin Setup & Configuration
-- -----------------------------------------------------------------------------
require("lazy").setup({
  -- == Core / UI ==
  { "nvim-lua/plenary.nvim" },   -- Utility functions, required by Telescope etc.

  {                              -- Fuzzy Finder (Replaces Command-T)
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local telescope = require('telescope')
      telescope.setup {
        defaults = {
          -- Default configuration for Telescope goes here
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
            },
          },
          sorting_strategy = "ascending",
          winblend = 0,
        },
        pickers = {
          -- Configuration for specific pickers can go here
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
          },
        },
        extensions = {
          -- Configuration for extensions, if any are installed
        }
      }
      -- Add keymaps for Telescope after setup
      local builtin = require('telescope.builtin')
      local map = vim.keymap.set
      map('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
      map('n', '<leader>fg', builtin.live_grep, { desc = 'Live Grep' })
      map('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      map('n', '<leader>fh', builtin.help_tags, { desc = 'Help Tags' })
      map('n', '<leader>fo', builtin.oldfiles, { desc = 'Find Old Files' })
      map('n', '<leader>gs', builtin.git_status, { desc = 'Git Status' })       -- Example Git integration
    end
  },
  -- == File Explorer (NvimTree) ==
  {
    'nvim-tree/nvim-tree.lua',
    version = "*",                         -- Use the latest stable version
    dependencies = {
      'nvim-tree/nvim-web-devicons',       -- OPTIONAL: for file icons
    },
    config = function()
      -- Disable netrw completely (redundant as you did it globally, but good practice)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- Optional: Enable true color support earlier if not done already
      vim.opt.termguicolors = true

      require('nvim-tree').setup({
        -- Recommended settings (customize to your liking):
        sort_by = "case_sensitive",
        view = {
          width = 35,           -- Adjust width as needed
          side = 'left',
          -- Preserve window structure on close
          preserve_window_proportions = true,
        },
        renderer = {
          group_empty = true,           -- Show ">" symbol for empty folders
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            -- Requires nvim-web-devicons and a Nerd Font
            glyphs = {
              default = "󰈚", -- Default icon
              symlink = "",
              folder = {
                arrow_closed = "", -- Arrow when folder is closed
                arrow_open = "", -- Arrow when folder is open
                default = "", -- Default folder icon
                open = "", -- Folder icon when open
                empty = "󰜌", -- Empty folder icon
                empty_open = "󰜌", -- Empty folder icon when open
              },
              git = {
                staged = "✓",
                unstaged = "✗",
                untracked = "★",
                renamed = "➜",
                ignored = "◌",
              },
            },
          },
        },
        filters = {
          dotfiles = false,                                                       -- Show dotfiles (hidden files)
          custom = { ".git", "node_modules", ".cache", "__pycache__" },           -- Hide these folders/files
          exclude = {},
        },
        git = {
          enable = true,
          ignore = false,           -- Show files listed in .gitignore
          timeout = 400,
        },
        -- Open files in the current window or horizontal split
        actions = {
          open_file = {
            quit_on_open = false,         -- Keep nvim-tree open after opening a file
            resize_window = true,         -- Resize window after opening file
            -- Use default bindings for opening files (e.g., Enter opens in current window)
            -- <C-v> opens in vertical split, <C-x> opens in horizontal split
          }
        },
        -- Tell nvim-tree to take over when you try to open a directory
        hijack_directories = {
          enable = true,
          auto_open = true,         -- Automatically open nvim-tree when opening a directory
        },
        -- Update focus when changing buffers
        update_focused_file = {
          enable = true,
          update_root = false,           -- Don't change root directory based on file focus
        },
        -- Add other options from nvim-tree documentation if needed
        -- :help nvim-tree.OPTION_NAME
      })

      -- Keymap to toggle NvimTree
      local map = vim.keymap.set
      local opts = { noremap = true, silent = true }
      -- Use <leader>e (Space + e in your case) to toggle the tree
      map('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle File Explorer (NvimTree)' })
      -- Optional: Map to focus the tree and find the current file
      map('n', '<leader>o', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle NvimTree Focus Current File' })
    end,
  },
  -- == TreeSitter ==
  {
    "nvim-treesitter/nvim-treesitter",
    -- build = ":TSUpdateSync", -- Or use build = ":TSUpdate" for async update
    build = function()
      -- Install parsers synchronously if required, useful for first time setup
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require('nvim-treesitter.configs').setup({
        -- A list of parser names, or "all" (may be slow)
        -- Install parsers for languages you commonly use
        ensure_installed = {
          "lua", "vim", "vimdoc", "query",     -- Base Neovim languages
          "bash", "c", "cpp", "go", "html", "css", "javascript",
          "typescript", "json", "yaml", "markdown", "markdown_inline",
          "python", "rust", "java", "haskell",
          -- Add others relevant to your work
        },

        -- Install parsers synchronously (only applies to `ensure_installed`)
        sync_install = false,   -- Set to true for synchronous first install if needed

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you manage `ensure_installed` manually
        auto_install = true,

        highlight = {
          enable = true,   -- Enable syntax highlighting based on Treesitter
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some weird jumps.
          -- NOTE: Disabled by default
          -- additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },   -- Enable indentation using treesitter
        -- Add other Treesitter modules if you need them (e.g., textobjects, incremental_selection)
        -- See :help nvim-treesitter-modules
      })

      -- Optional: Set keymaps for Treesitter features if desired
      -- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      -- vim.keymap.set({"n", "x", "o"}, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({"n", "x", "o"}, ",", ts_repeat_move.repeat_last_move_opposite)
      -- vim.keymap.set({"n", "x", "o"}, "f", ts_repeat_move.builtin_f)
      -- vim.keymap.set({"n", "x", "o"}, "F", ts_repeat_move.builtin_F)
      -- vim.keymap.set({"n", "x", "o"}, "t", ts_repeat_move.builtin_t)
      -- vim.keymap.set({"n", "x", "o"}, "T", ts_repeat_move.builtin_T)
    end,
  },

  -- == Git ==
  { 'tpope/vim-fugitive' },   -- Git wrapper (still the best!)

  -- == CodeCompanion ==
  {
    "olimorris/codecompanion.nvim",
    -- Explicitly list dependencies (good practice, though lazy may find them)
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    },
    config = function()
      require("codecompanion").setup({
        -- Basic configuration for Ollama:
        adapters = {
          ollama = function()
            -- Uses default Ollama settings (http://localhost:11434)
            -- You can customize host, model, etc. here if needed
            return require("codecompanion.adapters").ollama({
              -- model = "codellama", -- Specify a default model if desired
              -- host = "http://192.168.1.100:11434", -- If Ollama runs elsewhere
            })
          end,
        },
        -- Tell codecompanion to use the 'ollama' adapter for different tasks
        strategies = {
          chat = { adapter = "ollama" },
          inline = { adapter = "ollama" },
          agent = { adapter = "ollama" },
        },

        -- Add other configurations like keymaps, UI settings, etc.
        -- CHECK THE PLUGIN DOCUMENTATION FOR ALL OPTIONS!
        -- Example keymap (check docs for recommended mappings)
        -- keymap = {
        --   chat_toggle = "<leader>ac", -- Toggle chat window
        --   inline_toggle = "<leader>ai", -- Toggle inline actions
        -- },
      })
    end,
  },

  -- == Completion (Replaces CoC) ==
  {   -- Autocompletion Engine
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',               -- LSP source
      'hrsh7th/cmp-buffer',                 -- Buffer source
      'hrsh7th/cmp-path',                   -- Path source
      'hrsh7th/cmp-cmdline',                -- Command line source
      'L3MON4D3/LuaSnip',                   -- Snippet Engine
      'saadparwaiz1/cmp_luasnip',           -- Snippet source for nvim-cmp
      'rafamadriz/friendly-snippets',       -- Optional: useful snippets
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      -- Load friendly-snippets (optional)
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
          ['<C-Space>'] = cmp.mapping.complete(),                      -- Trigger completion
          ['<C-e>'] = cmp.mapping.abort(),                             -- Close completion
          ['<CR>'] = cmp.mapping.confirm({ select = true }),           -- Confirm selection (select=true is often default)
          -- Tab completion mapping:
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()                -- Fallback to default <Tab> behavior
            end
          end, { 'i', 's' }),           -- i: insert mode, s: select mode (for snippets)
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()               -- Fallback to default <S-Tab> behavior
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        -- Optional: Add borders or other styling to completion menu
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Setup nvim-cmp for command line
      cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        })
      })
    end
  },
  { 'L3MON4D3/LuaSnip' },   -- Snippet engine dependency

 -- == LSP (Language Server Protocol) ==
{
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', config = true }, -- Ensures Mason is set up
    'williamboman/mason-lspconfig.nvim',
    -- 'cmp_nvim_lsp' is already a dependency of 'nvim-cmp', so it's available
  },
  config = function()
    local lspconfig = require('lspconfig')
    local mason_lspconfig = require('mason-lspconfig')
    local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Get capabilities from nvim-cmp

    -- Configure mason-lspconfig:
    -- This single setup call will handle both ensuring LSPs are installed
    -- and setting up their configurations with lspconfig.
    mason_lspconfig.setup({
      -- List of LSPs to ensure are installed by Mason.
      ensure_installed = {
        "lua_ls",
        "pyright",
        "bashls",
        "dockerls",
        "jsonls",
        "yamlls",
        "rust_analyzer",
        "hls",
        "clangd"
        -- Add any other language servers you want Mason to manage here
      },
      -- Handlers for setting up each language server with nvim-lspconfig.
      handlers = {
        -- Default handler: This will be used for any server in 'ensure_installed'
        -- that doesn't have a specific handler defined below.
        function(server_name)
          lspconfig[server_name].setup {
            capabilities = capabilities,
            -- You can add a common on_attach here if needed, though your LspAttach autocmd is fine.
          }
        end,

        -- === Custom setups for specific servers ===
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false }, -- Optional: disable telemetry
              },
            },
          }
        end,
        ["pyright"] = function()
          lspconfig.pyright.setup {
            capabilities = capabilities,
            -- Add pyright specific settings here if needed, e.g.:
            -- settings = {
            --   python = {
            --     analysis = {
            --       typeCheckingMode = "basic", -- or "strict"
            --     }
            --   }
            -- }
          }
        end,
        ["rust_analyzer"] = function()
          lspconfig.rust_analyzer.setup {
            capabilities = capabilities,
            settings = {
              -- Note: Settings for rust-analyzer are typically nested under "rust-analyzer"
              ["rust-analyzer"] = {
                -- Example: enable clippy
                -- checkOnSave = { command = "clippy" }
              }
            }
            -- If you have a rust-project.json or the server is in $PATH, it often works without extra settings.
          }
        end,
        ["hls"] = function() -- Haskell Language Server
          lspconfig.hls.setup {
            capabilities = capabilities,
            settings = {
              -- Note: HLS settings are typically nested under "haskell"
              haskell = {
                -- Add HLS specific settings here if needed
              }
            }
          }
        end,
        ["clangd"] = function()
          lspconfig.clangd.setup {
            capabilities = capabilities,
            -- Add clangd specific settings here if needed
            -- cmd = {"clangd", "--offset-encoding=utf-16"}, -- Example for specific encoding if issues arise
          }
        end,
        -- Servers like bashls, dockerls, jsonls, yamlls from 'ensure_installed'
        -- will use the default handler defined above as they don't have specific overrides here.
      }
    })

    -- Keymaps for LSP actions (LspAttach autocommand)
    -- This part of your configuration is good and should remain as is.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }), -- Added clear = true
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

        print("LSP attached to buffer:", ev.buf, "Client ID:", ev.data.client_id) -- More informative print
      end
    })

  end,
}, 

  -- == Utility / Language Specific ==
  { 'junegunn/fzf',        build = './install --all' },        -- Core fzf (required by fzf.vim/telescope's fzf sorter)
  { 'junegunn/fzf.vim',    dependencies = { 'junegunn/fzf' } }, -- Basic fzf commands (optional if using Telescope heavily)

  { 'jgdavey/tslime.vim' },                                    -- Send code to tmux (kept from original)
  { 'thoughtbot/vim-rspec' },                                  -- RSpec integration (kept from original)

  { 'mattn/emmet-vim' },                                       -- HTML/CSS abbreviation expansion (Replaces Sparkup)


  -- == Deprecated / Replaced Plugins from original config ==
  -- 'neoclide/coc.nvim' -- Replaced by nvim-cmp & nvim-lspconfig
  -- 'wincent/command-t' -- Replaced by telescope.nvim
  -- 'rstacruz/sparkup' -- Replaced by emmet-vim or LSP features

}, {
  -- lazy.nvim options
  checker = { enabled = true },   -- Check for plugin updates automatically
})

-- -----------------------------------------------------------------------------
-- 5. General Key Mappings
--    Mappings not tied to specific plugins loaded above
-- -----------------------------------------------------------------------------
local map = vim.keymap.set
local gopts = { noremap = true, silent = true } -- Global options

-- Set leader key BEFORE mapping it. Default is '\'
vim.g.mapleader = ' '      -- Set leader key to '`'
vim.g.maplocalleader = ' ' -- Set localleader key to '`' (often useful)

-- Tslime Mappings (using leader now potentially)
map('v', '<leader>cc', '<Plug>SendSelectionToTmux', gopts)  -- Leader c c (visual)
map('n', '<leader>cc', '<Plug>NormalModeSendToTmux', gopts) -- Leader c c (normal)
map('n', '<leader>cr', '<Plug>SetTmuxVars', gopts)          -- Leader c r

-- Basic Navigation and Window Management
map('n', '<C-h>', '<C-w>h', gopts)      -- Navigate left window
map('n', '<C-j>', '<C-w>j', gopts)      -- Navigate down window
map('n', '<C-k>', '<C-w>k', gopts)      -- Navigate up window
map('n', '<C-l>', '<C-w>l', gopts)      -- Navigate right window
map('n', '<leader>wq', ':q<CR>', gopts) -- Quit window/nvim
map('n', '<leader>ww', ':w<CR>', gopts) -- Write buffer

-- Clear search highlight
map('n', '<leader><space>', ':nohlsearch<CR>', gopts)

-- Example: Map Escape in terminal mode
-- map('t', '<Esc>', '<C-\\><C-n>', gopts) -- Map Esc in terminal mode

-- -----------------------------------------------------------------------------
-- 6. Autocmds
--    Define autocommands if needed (e.g., for formatting on save)
-- -----------------------------------------------------------------------------
-- Example: Format on save (requires a formatter configured via LSP or null-ls/conform)
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = {"*.lua", "*.py", "*.go", "*.ts", "*.js", "*.rs"}, -- Add file types
--     callback = function()
--         vim.lsp.buf.format({ async = false }) -- Use async = false for BufWritePre
--     end,
--     group = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })
-- })


-- -----------------------------------------------------------------------------
-- 7. Colorscheme Loading
-- -----------------------------------------------------------------------------
-- Try loading the colorscheme. This should run after lazy.nvim setup.
-- Ensure 'leofltt-monochrome' is available:
-- 1. As a plugin listed in lazy.nvim setup (recommended).
-- 2. As a .vim file in ~/.config/nvim/colors/leofltt-monochrome.vim
local status_ok, _ = pcall(vim.cmd, 'colorscheme leofltt-monoish')
if not status_ok then
  print("Colorscheme 'leofltt-monoish' not found. Please install it or check the name.")
  -- Optionally load a fallback colorscheme
  -- vim.cmd('colorscheme default')
end
