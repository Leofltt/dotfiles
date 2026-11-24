-- Database viewer & query runner: vim-dadbod + vim-dadbod-ui + vim-dadbod-completion

local function is_sqlite_file(filepath)
  if not filepath or filepath == "" or vim.fn.filereadable(filepath) ~= 1 then
    return false
  end
  local f = io.open(filepath, "rb")
  if not f then
    return false
  end
  local header = f:read(16)
  f:close()
  return header == "SQLite format 3\0"
end

local function normalize_path(raw)
  local p = vim.trim(raw or "")
  if p == "" then
    return ""
  end
  if (#p >= 2) and ((p:sub(1, 1) == '"' and p:sub(-1) == '"') or (p:sub(1, 1) == "'" and p:sub(-1) == "'")) then
    p = p:sub(2, -2)
  end
  p = p:gsub("\\ ", " ")
  if p:match("^~") or p:match("^%%") then
    p = vim.fn.expand(p)
  end
  return vim.fn.fnamemodify(p, ":p")
end

local function path_under_nvimtree()
  if vim.bo.filetype ~= "NvimTree" then
    return nil
  end
  local ok, api = pcall(require, "nvim-tree.api")
  if not ok then
    return nil
  end
  local node = api.tree.get_node_under_cursor()
  if node and node.type == "file" and node.absolute_path and vim.fn.filereadable(node.absolute_path) == 1 then
    return node.absolute_path
  end
  return nil
end

return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DB",
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBOpenSQLite",
    },
    keys = {
      { "<leader>su", "<cmd>DBUIToggle<cr>", desc = "Toggle Database UI" },
      { "<leader>so", "<cmd>DBOpenSQLite<cr>", desc = "Open SQLite file (any extension)" },
      { "<leader>sa", "<cmd>DBUIAddConnection<cr>", desc = "Add Database Connection" },
      { "<leader>sf", "<cmd>DBUIFindBuffer<cr>", desc = "Find Database Buffer" },
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 35
    end,
    config = function()
      vim.api.nvim_create_user_command("DBOpenSQLite", function(opts)
        local path = opts.args
        local from_current_buf = false

        if path == "" then
          local tree_path = path_under_nvimtree()
          local cur = vim.api.nvim_buf_get_name(0)
          if tree_path then
            path = tree_path
          elseif is_sqlite_file(cur) then
            path = cur
            from_current_buf = true
          else
            path = vim.fn.input("SQLite DB file: ", vim.fn.getcwd() .. "/", "file")
          end
        end

        local abs_path = normalize_path(path)
        if abs_path == "" then
          return
        end

        if vim.fn.filereadable(abs_path) ~= 1 then
          vim.notify("File not readable: " .. abs_path, vim.log.levels.ERROR)
          return
        end

        if vim.fn.getfsize(abs_path) > 0 and not is_sqlite_file(abs_path) then
          vim.notify("Warning: file does not have a SQLite 3 header: " .. abs_path, vim.log.levels.WARN)
        end

        local ok_enc, encoded = pcall(vim.fn["db#url#path_encode"], abs_path)
        local url = "sqlite:" .. (ok_enc and encoded or abs_path)

        local dbs = vim.g.dbs or {}
        local name = vim.fn.fnamemodify(abs_path, ":t")
        dbs[name] = url
        vim.g.dbs = dbs

        if from_current_buf then
          vim.cmd("enew")
        end
        vim.b.db = url

        pcall(vim.cmd, "DBUIClose")
        pcall(vim.fn["db_ui#reset_state"])
        vim.cmd("DBUI")
      end, { nargs = "?", complete = "file", desc = "Open any SQLite DB file in Dadbod UI" })
    end,
  },
}
