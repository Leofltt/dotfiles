-- Python IDE: virtualenv selector + debugpy adapter

return {
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    ft = "python",
    cmd = "VenvSelect",
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-telescope/telescope.nvim",
    },
    opts = {},
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", ft = "python", desc = "Select Python venv" },
    },
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local mason_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local python_path = vim.fn.executable(mason_python) == 1 and mason_python or "python3"
      require("dap-python").setup(python_path)
    end,
  },
}
