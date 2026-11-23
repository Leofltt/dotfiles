-- C / C++ IDE extras: clangd extensions + CMake + Ninja + codelldb integration

return {
  {
    "p00f/clangd_extensions.nvim",
    ft = { "c", "cpp", "objc", "objcpp" },
    opts = {},
    keys = {
      { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", ft = { "c", "cpp", "objc", "objcpp" }, desc = "Switch source/header" },
      { "<leader>ct", "<cmd>ClangdTypeHierarchy<cr>", ft = { "c", "cpp", "objc", "objcpp" }, desc = "Type hierarchy" },
    },
  },

  {
    "Civitasv/cmake-tools.nvim",
    ft = { "c", "cpp", "cmake" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1", "-G", "Ninja" },
      cmake_soft_link_compile_commands = true,
      cmake_dap_configuration = {
        name = "cpp",
        type = "codelldb",
        request = "launch",
        stopOnEntry = false,
        runInTerminal = false,
      },
    },
    keys = {
      { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake Generate" },
      { "<leader>cb", "<cmd>CMakeBuild<cr>", desc = "CMake Build" },
      { "<leader>cx", "<cmd>CMakeRun<cr>", desc = "CMake Run" },
      { "<leader>cd", "<cmd>CMakeDebug<cr>", desc = "CMake Debug (LLDB)" },
      { "<leader>cT", "<cmd>CMakeSelectBuildTarget<cr>", desc = "CMake Select Target" },
    },
  },
}
