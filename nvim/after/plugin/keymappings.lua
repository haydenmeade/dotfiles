local M = {}

local keymap = require "utils.keymap"

local keymappings = {
  insert_mode = {},
  normal_mode = {
    -- resizing splits
    ["<A-left>"] = "<Cmd>lua require('smart-splits').resize_left(5)<CR>",
    ["<A-down>"] = "<Cmd>lua require('smart-splits').resize_down(5)<CR>",
    ["<A-up>"] = "<Cmd>lua require('smart-splits').resize_up(5)<CR>",
    ["<A-right>"] = "<Cmd>lua require('smart-splits').resize_right(5)<CR>",
    -- moving between splits
    ["<C-left>"] = "<Cmd>lua require('smart-splits').move_cursor_left()<CR>",
    ["<C-down>"] = "<Cmd>lua require('smart-splits').move_cursor_down()<CR>",
    ["<C-up>"] = "<Cmd>lua require('smart-splits').move_cursor_up()<CR>",
    ["<C-right>"] = "<Cmd>lua require('smart-splits').move_cursor_right()<CR>",
  },
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
