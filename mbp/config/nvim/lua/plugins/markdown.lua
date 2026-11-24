-- In-buffer Markdown rendering (works in Markdown files and CodeCompanion chat)

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = false,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      {
        "<leader>um",
        "<cmd>RenderMarkdown toggle<cr>",
        ft = { "markdown", "codecompanion" },
        desc = "Toggle Markdown rendering",
      },
    },
    opts = {
      file_types = { "markdown", "codecompanion" },
      html = { enabled = false },
      latex = { enabled = false },
      completions = {
        lsp = { enabled = true },
      },
    },
  },

  {
    "3rd/image.nvim",
    ft = { "markdown", "codecompanion" },
    opts = {
      backend = "kitty",
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width_window_percentage = 80,
      max_height_window_percentage = 40,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "blink-cmp-menu", "blink-cmp-documentation", "" },
      tmux_show_only_in_active_window = true,
    },
  },

  {
    "3rd/diagram.nvim",
    ft = { "markdown" },
    dependencies = { "3rd/image.nvim" },
    opts = function()
      local cli_args = nil
      for _, browser in ipairs({
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome",
        "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
      }) do
        if vim.fn.executable(browser) == 1 then
          local cache_dir = vim.fn.stdpath("cache") .. "/diagram-cache"
          vim.fn.mkdir(cache_dir, "p")
          local cfg_path = cache_dir .. "/puppeteer.json"
          vim.fn.writefile({ vim.json.encode({ executablePath = browser }) }, cfg_path)
          cli_args = { "-p", vim.fn.shellescape(cfg_path) }
          break
        end
      end

      return {
        events = {
          render_buffer = { "InsertLeave", "BufWinEnter", "TextChanged" },
          clear_buffer = { "BufLeave" },
        },
        renderer_options = {
          mermaid = {
            background = "transparent",
            theme = "dark",
            scale = 2,
            cli_args = cli_args,
          },
        },
      }
    end,
  },

  {
    "brianhuster/live-preview.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    cmd = { "LivePreview" },
    keys = {
      {
        "<leader>up",
        function()
          local ok, lp = pcall(require, "livepreview")
          if ok and lp.is_running and lp.is_running() then
            vim.cmd("LivePreview close")
          else
            vim.cmd("LivePreview start")
          end
        end,
        ft = { "markdown", "html", "svg", "asciidoc" },
        desc = "Toggle browser Markdown preview (Mermaid/KaTeX)",
      },
    },
    config = function()
      require("livepreview.config").set({
        sync_scroll = true,
        autokill = true,
      })
    end,
  },
}
