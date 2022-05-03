local M = {}

function M.setup()
  local ok, term = h.safe_require "toggleterm"
  if not ok then
    return
  end
  term.setup {
    size = 20,
    hide_numbers = true,
    -- open_mapping = [[<c-\>]],
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 0.3,
    close_on_exit = true, -- close the terminal window when the process exits
    start_in_insert = true,
    persist_size = true,
    direction = "horizontal", --'vertical' | 'horizontal' | 'window' | 'float'
  }
end

local terminal = require("toggleterm.terminal").Terminal
M.lazygit_term = terminal:new {
  cmd = "lazygit",
  direction = "tab",
  hidden = true,
}

function M.lazygit_toggle()
  M.lazygit_term:toggle()
end

return M
