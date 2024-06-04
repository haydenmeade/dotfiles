local M = {}
local Log = require("core.log")

---Join path segments that were passed as input
---@return string
function _G.join_paths(...)
  local path_sep = "/"
  local result = table.concat({ ... }, path_sep)
  return result
end

---Get the full path to `$VIM_RUNTIME_DIR`
---@return string
function _G.get_runtime_dir()
  -- when nvim is used directly
  return vim.fn.stdpath("data")
end

---Get the full path to `$VIM_CONFIG_DIR`
---@return string
function _G.get_config_dir()
  return vim.fn.stdpath("config")
end

---Get the full path to `$VIM_CACHE_DIR`
---@return string
function _G.get_cache_dir()
  return vim.fn.stdpath("cache")
end

function M.get_os_command_output(cmd, cwd)
  local Job = require("plenary.job")
  if type(cmd) ~= "table" then
    Log:error("get_os_command_output", {
      msg = "cmd has to be a table",
      level = "ERROR",
    })
    return {}
  end
  local command = table.remove(cmd, 1)
  local stderr = {}
  local stdout, ret = Job:new({
    command = command,
    args = cmd,
    cwd = cwd,
    on_stderr = function(_, data)
      table.insert(stderr, data)
    end,
  }):sync()
  return stdout, ret, stderr
end

-- Reload all user config lua modules
M.Reload = function()
  local lua_dirs = vim.fn.glob("./lua/*", 0, 1)
  for _, dir in ipairs(lua_dirs) do
    dir = string.gsub(dir, "./lua/", "")
    require("plenary.reload").reload_module(dir)
  end
end

local get_mapper = function(mode, noremap)
  return function(lhs, rhs, opts)
    opts = opts or {}
    opts.noremap = noremap
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

M.noremap = get_mapper("n", false)
M.nnoremap = get_mapper("n", true)
M.inoremap = get_mapper("i", true)
M.tnoremap = get_mapper("t", true)
M.vnoremap = get_mapper("v", true)

function M.createmap(mode, mapping, prefix)
  local mapping_prefix = prefix or ""
  local mapping_opts = { noremap = true, silent = true, expr = false }
  for keys, cmd in pairs(mapping) do
    if type(cmd) == "table" then
      M.createmap(mode, cmd, mapping_prefix .. keys)
    else
      vim.keymap.set(mode, mapping_prefix .. keys, cmd, mapping_opts)
      -- vim.api.nvim_set_keymap(mode, mapping_prefix .. keys, cmd, mapping_opts)
    end
  end
end

function M.createmap_buffer(mode, mapping, prefix, bufnr)
  local mapping_prefix = prefix or ""
  local mapping_opts = { noremap = true, silent = true, expr = false }
  for keys, cmd in pairs(mapping) do
    if type(cmd) == "table" then
      M.createmap_buffer(mode, cmd, mapping_prefix .. keys, bufnr)
    else
      vim.api.nvim_buf_set_keymap(bufnr, mode, mapping_prefix .. keys, cmd, mapping_opts)
    end
  end
end

return M
