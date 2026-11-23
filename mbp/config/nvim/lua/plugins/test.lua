-- Test runner (Neotest) for Python, Rust, C++ (GTest), and Haskell

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
      "mrcjkb/neotest-haskell",
      "alfaix/neotest-gtest",
    },
    keys = {
      { "<leader>tn", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
      { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Open test output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle test output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test" },
    },
    config = function()
      local adapters = {}

      local ok_py, neotest_python = pcall(require, "neotest-python")
      if ok_py then
        table.insert(adapters, neotest_python({ dap = { justMyCode = false } }))
      end

      local ok_rs, rust_neotest = pcall(require, "rustaceanvim.neotest")
      if ok_rs then
        table.insert(adapters, rust_neotest)
      end

      local ok_hs, neotest_haskell = pcall(require, "neotest-haskell")
      if ok_hs then
        table.insert(adapters, neotest_haskell)
      end

      local ok_cpp, neotest_gtest = pcall(require, "neotest-gtest")
      if ok_cpp and neotest_gtest.setup then
        table.insert(adapters, neotest_gtest.setup({}))
      end

      require("neotest").setup({
        adapters = adapters,
      })
    end,
  },
}
