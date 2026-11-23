-- Csound syntax and tmux REPL integration

return {
  { "luisjure/csound-vim", ft = { "csound", "csd" } },
  {
    "kunstmusik/csound-repl",
    ft = { "csound", "csd" },
    config = function()
      vim.g.csound_repl_target = "tmux"
      vim.api.nvim_create_augroup("CsoundReplPortConfig", { clear = true })
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = "CsoundReplPortConfig",
        pattern = "*.csd,*.csound",
        callback = function()
          if vim.fn.exists("Csound_set_port") == 1 then
            vim.cmd("call Csound_set_port(11000)")
          end
        end,
        once = true,
      })
    end,
  },
}
