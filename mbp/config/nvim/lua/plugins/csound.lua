return {
  -- csound-vim for syntax highlighting, folding, etc.
  {
    "luisjure/csound-vim",
    -- You might want to lazy-load this on Csound file types
    ft = { "csound", "csd" },
    -- Optional: if you want to explicitly run setup (csound-vim doesn't have a setup function in the same way other plugins do)
    -- You can configure specific options as documented in csound-vim's README.
    -- For example, to disable syntax folding if it causes performance issues:
    -- config = function()
    --   vim.cmd("autocmd Syntax csound setlocal foldmethod=manual")
    -- end,
  },

  -- csound-repl for live coding
  {
    "kunstmusik/csound-repl",
    -- It's often useful to lazy-load REPLs as well
    ft = { "csound", "csd" },
    -- You'll likely want to configure csound-repl.
    -- Refer to its GitHub README for configuration options.
    -- Example (assuming you use tmux for the REPL):
    -- config = function()
    --   vim.g.csound_repl_target = "tmux" -- Or "terminal" or "external"
    --   -- Add other csound-repl specific configurations here
    -- end,
  },
}
