-- Core editor tools: Telescope, NvimTree, Treesitter (0.12 main branch), autopairs, tslime

return {
  { "nvim-lua/plenary.nvim", lazy = true },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
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
      })
      pcall(telescope.load_extension, "fzf")

      local builtin = require("telescope.builtin")
      local map = vim.keymap.set
      map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Help Tags" })
      map("n", "<leader>fo", builtin.oldfiles, { desc = "Find Old Files" })
      map("n", "<leader>gs", builtin.git_status, { desc = "Git Status" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = { width = 35, side = "left", preserve_window_proportions = true },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
        },
        filters = { dotfiles = false, custom = { ".git", "node_modules", ".cache", "__pycache__" } },
        git = { enable = true, ignore = false, timeout = 400 },
        actions = { open_file = { quit_on_open = false, resize_window = true } },
        hijack_directories = { enable = true, auto_open = true },
        update_focused_file = { enable = true, update_root = false },
      })

      local map = vim.keymap.set
      map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
      map("n", "<leader>o", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle NvimTree & Find File" })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local ok, ts = pcall(require, "nvim-treesitter")
      if not ok then
        return
      end
      if ts.setup then
        ts.setup({})
      end

      -- Installing parsers on the `main` branch requires `tree-sitter` CLI
      if vim.fn.executable("tree-sitter") == 1 and ts.install and ts.get_installed then
        local wanted = {
          "c",
          "cpp",
          "cmake",
          "rust",
          "toml",
          "haskell",
          "python",
          "lua",
          "vim",
          "vimdoc",
          "query",
          "bash",
          "json",
          "yaml",
          "markdown",
          "markdown_inline",
        }
        local installed_parsers = {}
        for _, l in ipairs(ts.get_installed("parsers") or {}) do
          installed_parsers[l] = true
        end
        local installed_queries = {}
        for _, l in ipairs(ts.get_installed("queries") or {}) do
          installed_queries[l] = true
        end
        local missing = {}
        for _, lang in ipairs(wanted) do
          if not (installed_parsers[lang] and installed_queries[lang]) then
            table.insert(missing, lang)
          end
        end
        if #missing > 0 then
          pcall(ts.install, missing)
        end
      end
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  { "jgdavey/tslime.vim" },

  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", desc = "Focus left split / tmux pane" },
      { "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", desc = "Focus lower split / tmux pane" },
      { "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", desc = "Focus upper split / tmux pane" },
      { "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", desc = "Focus right split / tmux pane" },
      { "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", desc = "Focus previous split / tmux pane" },
    },
  },
}
