local M = {}
local Log = require "core.log"

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
  return vim.fn.stdpath "data"
end

---Get the full path to `$VIM_CONFIG_DIR`
---@return string
function _G.get_config_dir()
  return vim.fn.stdpath "config"
end

---Get the full path to `$VIM_CACHE_DIR`
---@return string
function _G.get_cache_dir()
  return vim.fn.stdpath "cache"
end

-- local Log = require("core.log")

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

---Reset any startup cache files used by Packer and Impatient
---It also forces regenerating any template ftplugin files
---Tip: Useful for clearing any outdated settings
function M.reset_cache()
  local impatient = _G.__luacache
  if impatient then
    impatient.clear_cache()
  end
  local modules = {}
  for module, _ in pairs(package.loaded) do
    if module:match "core" or module:match "lsp" then
      package.loaded[module] = nil
      table.insert(modules, module)
    end
  end
  Log:trace(string.format("Cache invalidated for core modules: { %s }", table.concat(modules, ", ")))
end

return M
