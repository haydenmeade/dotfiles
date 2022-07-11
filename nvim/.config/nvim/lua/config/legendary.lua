local M = {}

local keymap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

function M.setup()
  local ok, lg = h.safe_require("legendary")
  if not ok then
    return
  end
  lg.setup({ include_builtin = true, auto_register_which_key = true })
  keymap("n", "<C-p>", "<cmd>lua require('legendary').find()<CR>", default_opts)
end

return M
