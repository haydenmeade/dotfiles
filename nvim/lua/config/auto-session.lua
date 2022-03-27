local M = {}

local function close_nvim_tree()
  -- local nvim_tree = require "nvim-tree"
  -- nvim_tree.change_dir(vim.fn.getcwd())
  -- nvim_tree.refresh()
end

function M.setup()
  require("auto-session").setup {
    log_level = "error",
    pre_save_cmds = { close_nvim_tree },
  }
end

return M
