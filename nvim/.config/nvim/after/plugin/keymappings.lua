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
    ["<A-left>"] = "<Cmd>lua require('tmux').resize_left()<CR>",
    ["<A-down>"] = "<Cmd>lua require('tmux').resize_down()<CR>",
    ["<A-up>"] = "<Cmd>lua require('tmux').resize_up()<CR>",
    ["<A-right>"] = "<Cmd>lua require('tmux').resize_right()<CR>",
    -- moving between splits
    ["<C-left>"] = "<cmd>lua require('tmux').move_left()<cr>",
    ["<C-down>"] = "<Cmd>lua require('tmux').move_down()<CR>",
    ["<C-up>"] = "<Cmd>lua require('tmux').move_up()<CR>",
    ["<C-right>"] = "<Cmd>lua require('tmux').move_right()<CR>",
  },
  [""] = {
    -- moving splits
    ["<C-S-left>"] = "<C-W>H",
    ["<C-S-down>"] = "<C-W>J",
    ["<C-S-up>"] = "<C-W>K",
    ["<C-S-right>"] = "<C-W>L",
    -- resizing splits
    ["<A-left>"] = "<Cmd>lua require('tmux').resize_left()<CR>",
    ["<A-down>"] = "<Cmd>lua require('tmux').resize_down()<CR>",
    ["<A-up>"] = "<Cmd>lua require('tmux').resize_up()<CR>",
    ["<A-right>"] = "<Cmd>lua require('tmux').resize_right()<CR>",
    -- moving between splits
    ["<C-left>"] = "<cmd>lua require('tmux').move_left()<cr>",
    ["<C-down>"] = "<Cmd>lua require('tmux').move_down()<CR>",
    ["<C-up>"] = "<Cmd>lua require('tmux').move_up()<CR>",
    ["<C-right>"] = "<Cmd>lua require('tmux').move_right()<CR>",
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
