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
      map("n", "<leader>gb", builtin.git_branches, { desc = "Git Branches" })
      map("n", "<leader>gc", builtin.git_commits, { desc = "Git Commits" })
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
        actions = {
          open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
              exclude = {
                filetype = {
                  "notify",
                  "packer",
                  "qf",
                  "diff",
                  "fugitive",
                  "fugitiveblame",
                  "codecompanion",
                  "dbui",
                  "dbout",
                  "trouble",
                  "dapui_scopes",
                  "dapui_stacks",
                  "dapui_breakpoints",
                  "dapui_watches",
                  "dapui_console",
                  "dap-repl",
                },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
        },
        hijack_directories = { enable = false, auto_open = false },
        update_focused_file = { enable = true, update_root = false },
      })

      -- On `nvim .`, keep an empty editor window beside NvimTree so opening files never overwrites or squashes splits
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("UserNvimTreeDir", { clear = true }),
        callback = function(data)
          if vim.fn.isdirectory(data.file) ~= 1 then
            return
          end
          vim.cmd.cd(data.file)
          vim.cmd("enew")
          pcall(vim.cmd, "bwipeout! " .. data.buf)
          require("nvim-tree.api").tree.open()
        end,
      })

      -- If all code splits were closed (:q) so NvimTree expanded, restore tree + AI split widths on next file open
      local tree_width = 35
      vim.api.nvim_create_autocmd("BufWinEnter", {
        group = vim.api.nvim_create_augroup("UserNvimTreeRestoreWidth", { clear = true }),
        callback = function(ev)
          if vim.bo[ev.buf].buftype ~= "" or vim.bo[ev.buf].filetype == "NvimTree" then
            return
          end
          vim.schedule(function()
            local tree_win = require("nvim-tree.view").get_winnr()
            if not tree_win or not vim.api.nvim_win_is_valid(tree_win) then
              return
            end
            if vim.api.nvim_win_get_width(tree_win) <= tree_width then
              return
            end
            vim.api.nvim_win_set_width(tree_win, tree_width)
            for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
              local saved = vim.w[win].ai_term_width
              if saved and vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_set_width(win, saved)
              end
            end
          end)
        end,
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
          "sql",
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
