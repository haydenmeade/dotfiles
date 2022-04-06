_G.h = {}
local os_name = vim.loop.os_uname().sysname

function h:load_variables()
  h.is_mac = os_name == "Darwin"
  h.is_linux = os_name == "Linux"
  h.is_windows = os_name == "Windows" or os_name == "Windows_NT"
  if self.is_windows then
    h.path_sep = "\\"
  else
    h.path_sep = "/"
  end
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
