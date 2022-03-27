local M = {}

local keymap = require "utils.keymap"

local keymappings = {
  insert_mode = {},
  normal_mode = {
    ["<Esc><Esc>"] = "<Cmd>noh<CR>",
    ["<C-w><C-o>"] = "<Cmd>MaximizerToggle!<CR>",
    ["<M-left>"] = "<C-w>>",
    ["<M-right>"] = "<C-w><",
    ["<M-up>"] = "<C-w>+",
    ["<M-down>"] = "<C-w>-",
    ["Y"] = "y$",
    [",h"] = "<Cmd>wincmd h<Cr>",
    [",j"] = "<Cmd>wincmd j<Cr>",
    [",l"] = "<Cmd>wincmd l<Cr>",
    [",k"] = "<Cmd>wincmd k<Cr>",
    [",s"] = "<Cmd>split<Cr>",
    [",v"] = "<Cmd>vs<Cr>",
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
