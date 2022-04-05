local home = os.getenv "HOME"
local path_sep = h.is_windows and "\\" or "/"
local os_name = vim.loop.os_uname().sysname
_G.h = {}

function h:load_variables()
  self.is_mac = os_name == "Darwin"
  self.is_linux = os_name == "Linux"
  self.is_windows = os_name == "Windows" or os_name == "Windows_NT"
  self.vim_path = vim.fn.stdpath "config"
  if self.is_windows then
    path_sep = "\\"
  end

  self.cache_dir = home .. path_sep .. ".cache" .. path_sep .. "nvim" .. path_sep
  -- self.modules_dir = self.vim_path .. path_sep .. 'modules'
  self.modules_dir = self.vim_path .. path_sep .. "lua" .. path_sep .. "packer_compiled.lua"
  self.path_sep = path_sep
  self.home = home
  self.data_dir = string.format("%s%ssite%s", vim.fn.stdpath "data", path_sep, path_sep)
  self.cache_dir = vim.fn.stdpath "cache"
  self.log_dir = string.format("%s", self.cache_dir)

  self.log_path = string.format("%s%s%s", self.log_dir, path_sep, "nvim_debug.log")
end

h:load_variables()

---Require a module using [pcall] and report any errors
---@param module string
---@param opts table?
---@return boolean, any
function h.safe_require(module, opts)
  opts = opts or { silent = false }
  local ok, result = pcall(require, module)
  if not ok and not opts.silent then
    vim.notify(result, vim.log.levels.ERROR, { title = string.format("Error requiring: %s", module) })
  end
  return ok, result
end
