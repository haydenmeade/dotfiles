local M = {}

local function close_nvim_tree()
  local nvim_tree = require "nvim-tree"
  nvim_tree.close()
end

function M.setup()
  require("auto-session").setup {
    log_level = "error",
    pre_save_cmds = { "NvimTreeClose" },
  }
end

return M
