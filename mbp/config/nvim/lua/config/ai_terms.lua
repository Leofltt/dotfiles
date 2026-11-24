-- Persistent zero-plugin CLI agent side splits (Antigravity, Pi, OpenCode, Hermes)

local agents = {
  agy = { lhs = "<leader>ag", cmd = "agy", desc = "Toggle Antigravity (agy)" },
  pi = { lhs = "<leader>ap", cmd = "pi", desc = "Toggle Pi agent" },
  opencode = { lhs = "<leader>ao", cmd = "opencode", desc = "Toggle OpenCode" },
  hermes = { lhs = "<leader>ah", cmd = "hermes", desc = "Toggle Hermes agent" },
}

local state = {}
local last_agent = nil

local function is_alive(s)
  return s and s.job and vim.fn.jobwait({ s.job }, 0)[1] == -1
end

local function configure_term_win(win, buf)
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].winfixwidth = true
  -- Keep <Esc> free for agent TUIs; Ctrl+h jumps back to the code split
  vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], {
    buffer = buf,
    noremap = true,
    silent = true,
    desc = "Focus code split from AI terminal",
  })
end

local function open_agent(name)
  local cfg = agents[name]
  local s = state[name] or {}
  state[name] = s

  if s.win and vim.api.nvim_win_is_valid(s.win) then
    vim.api.nvim_set_current_win(s.win)
    last_agent = name
    vim.cmd("startinsert")
    return true
  end

  local default_w = math.max(45, math.min(math.floor(vim.o.columns * 0.40), vim.o.columns - 45))
  local width = (s.width and s.width >= 30 and s.width <= vim.o.columns - 30) and s.width or default_w
  vim.cmd("botright vsplit")
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_width(win, width)
  s.width = width
  vim.w[win].ai_term_width = width

  if s.buf and vim.api.nvim_buf_is_valid(s.buf) and is_alive(s) then
    vim.api.nvim_win_set_buf(win, s.buf)
    configure_term_win(win, s.buf)
    s.win = win
    last_agent = name
    vim.cmd("startinsert")
    return true
  end

  if vim.fn.executable(cfg.cmd) ~= 1 then
    vim.api.nvim_win_close(win, true)
    vim.notify("'" .. cfg.cmd .. "' not found on PATH", vim.log.levels.ERROR)
    return false
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "hide"
  vim.api.nvim_win_set_buf(win, buf)

  local job = vim.fn.jobstart(cfg.cmd, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        s.job = nil
        if s.win and vim.api.nvim_win_is_valid(s.win) then
          pcall(vim.api.nvim_win_close, s.win, true)
        end
        s.win = nil
        if s.buf and vim.api.nvim_buf_is_valid(s.buf) then
          pcall(vim.api.nvim_buf_delete, s.buf, { force = true })
        end
        s.buf = nil
      end)
    end,
  })

  if job <= 0 then
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.notify("Failed to start '" .. cfg.cmd .. "'", vim.log.levels.ERROR)
    return false
  end

  s.buf = buf
  s.win = win
  s.job = job
  last_agent = name
  configure_term_win(win, buf)
  vim.cmd("startinsert")
  return true
end

local function toggle_agent(name)
  local s = state[name]
  if s and s.win and vim.api.nvim_win_is_valid(s.win) then
    vim.api.nvim_win_close(s.win, true)
    s.win = nil
    return
  end
  open_agent(name)
end

local function pick_target_agent()
  for name, s in pairs(state) do
    if s.win and vim.api.nvim_win_is_valid(s.win) and is_alive(s) then
      return name
    end
  end
  if last_agent and is_alive(state[last_agent]) then
    return last_agent
  end
  return nil
end

local function send_context()
  local target = pick_target_agent()
  if not target then
    vim.notify("No active AI CLI terminal. Open one with Space a g / p / o / h.", vim.log.levels.WARN)
    return
  end

  local rel = vim.fn.expand("%:.")
  if rel == "" then
    vim.notify("Current buffer has no file path.", vim.log.levels.WARN)
    return
  end

  local mode = vim.fn.mode()
  local payload
  if mode == "v" or mode == "V" or mode == "\22" then
    local l1 = vim.fn.line("v")
    local l2 = vim.fn.line(".")
    local s_line, e_line = math.min(l1, l2), math.max(l1, l2)
    payload = string.format("%s:%d-%d ", rel, s_line, e_line)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
  else
    payload = rel .. " "
  end

  if open_agent(target) then
    vim.api.nvim_chan_send(state[target].job, payload)
  end
end

for name, cfg in pairs(agents) do
  vim.keymap.set("n", cfg.lhs, function()
    toggle_agent(name)
  end, { noremap = true, silent = true, desc = cfg.desc })
end

vim.keymap.set({ "n", "v" }, "<leader>as", send_context, {
  noremap = true,
  silent = true,
  desc = "Send file/selection to active AI CLI",
})

vim.api.nvim_create_autocmd("WinResized", {
  group = vim.api.nvim_create_augroup("UserAiTermResize", { clear = true }),
  callback = function()
    local cur = vim.api.nvim_get_current_win()
    for _, s in pairs(state) do
      if s.win and s.win == cur and vim.api.nvim_win_is_valid(s.win) then
        local w = vim.api.nvim_win_get_width(s.win)
        if w >= 30 then
          s.width = w
          vim.w[s.win].ai_term_width = w
        end
      end
    end
  end,
})
