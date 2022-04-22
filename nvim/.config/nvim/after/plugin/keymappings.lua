local M = {}

local keymappings = {
  i = {},
  n = {
    j = "gj",
    k = "gk",
  },
  v = {
    ["C-s"] = "zy<Cmd>Telescope live_grep default_text=<C-r>z<cr>",
  },
  t = {
    ["<esc>"] = [[<C-\><C-n>]],
    -- moving splits
    ["<C-S-left>"] = "<C-W>H",
    ["<C-S-down>"] = "<C-W>J",
    ["<C-S-up>"] = "<C-W>K",
    ["<C-S-right>"] = "<C-W>L",
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
  [""] = {
    -- moving splits
    ["<C-S-left>"] = "<C-W>H",
    ["<C-S-down>"] = "<C-W>J",
    ["<C-S-up>"] = "<C-W>K",
    ["<C-S-right>"] = "<C-W>L",
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
}

function M.setup()
  local opts = { noremap = true, silent = true }
  for mode, mapping in pairs(keymappings) do
    for keys, cmd in pairs(mapping) do
      vim.api.nvim_set_keymap(mode, keys, cmd, opts)
    end
  end
end

M.setup()
