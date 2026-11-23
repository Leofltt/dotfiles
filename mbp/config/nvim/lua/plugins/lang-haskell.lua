-- Haskell IDE: haskell-tools.nvim (HLS via ghcup, Hoogle, GHCi REPL, code lenses)

return {
  {
    "mrcjkb/haskell-tools.nvim",
    version = "^6",
    lazy = false,
    init = function()
      vim.g.haskell_tools = {
        tools = {
          codeLens = {
            -- Avoid haskell-tools' deprecated vim.lsp.codelens.refresh() on Neovim 0.12
            autoRefresh = false,
          },
        },
        hls = {
          on_attach = function(_, bufnr, ht)
            if vim.lsp.codelens and vim.lsp.codelens.enable then
              vim.lsp.codelens.enable(true, { bufnr = bufnr })
            end

            local function map(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
            end
            map("<leader>lh", ht.hoogle.hoogle_signature, "Hoogle signature search")
            map("<leader>le", ht.lsp.buf_eval_all, "Evaluate all code lenses")
            map("<leader>lr", ht.repl.toggle, "Toggle GHCi REPL (package)")
            map("<leader>lf", function()
              ht.repl.toggle(vim.api.nvim_buf_get_name(bufnr))
            end, "Toggle GHCi REPL (buffer)")
            map("<leader>lq", ht.repl.quit, "Quit GHCi REPL")
            map("<leader>cl", vim.lsp.codelens.run, "Run code lens")
          end,
        },
      }
    end,
  },
}
