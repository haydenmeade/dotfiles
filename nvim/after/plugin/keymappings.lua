local M = {}

local keymap = require "utils.keymap"

local keymappings = {
  insert_mode = {},
  normal_mode = {},
  visual_mode = {},
  term_mode = {
    ["<esc>"] = [[<C-\><C-n>]],
  },
  command_mode = {},
}

function M.setup()
  for mode, mapping in pairs(keymappings) do
    keymap.map(mode, mapping)
  end
end

M.setup()
