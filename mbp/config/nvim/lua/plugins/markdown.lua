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
}
