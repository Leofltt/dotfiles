-- Rust IDE: rustaceanvim (manages rust-analyzer + clippy + codelldb) & crates.nvim

return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        local dap_cfg = {}
        local ok, cfg = pcall(require, "rustaceanvim.config")
        if ok and cfg.get_codelldb_adapter then
          local pkg_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
          local codelldb_path = pkg_path .. "adapter/codelldb"
          local liblldb_path = pkg_path .. "lldb/lib/liblldb.dylib"
          if vim.fn.executable(codelldb_path) == 1 and vim.fn.filereadable(liblldb_path) == 1 then
            dap_cfg.adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path)
          end
        end

        return {
          server = {
            on_attach = function(_, bufnr)
              local function map(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
              end
              map("<leader>rr", "<cmd>RustLsp runnables<cr>", "Rust runnables")
              map("<leader>rd", "<cmd>RustLsp debuggables<cr>", "Rust debuggables (LLDB)")
              map("<leader>re", "<cmd>RustLsp expandMacro<cr>", "Rust expand macro")
              map("<leader>rc", "<cmd>RustLsp openCargo<cr>", "Open Cargo.toml")
              map("<leader>rp", "<cmd>RustLsp parentModule<cr>", "Parent module")
              map("<leader>rk", "<cmd>RustLsp hover actions<cr>", "Rust hover actions")
            end,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true },
                check = { command = "clippy" },
                procMacro = { enable = true },
              },
            },
          },
          dap = dap_cfg,
        }
      end
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
}
