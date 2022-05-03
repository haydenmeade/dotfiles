local M = {}

local keymappings = {
  i = {},
  n = {
    j = "gj",
    k = "gk",
    ["<c-\\>"] = "<cmd>lua require('config.tmux').toggle_term()<cr>",
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
    ["<A-down>"] = "<Cmd>lua require('tmux').resize_bottom()<CR>",
    ["<A-up>"] = "<Cmd>lua require('tmux').resize_top()<CR>",
    ["<A-right>"] = "<Cmd>lua require('tmux').resize_right()<CR>",
    -- moving between splits
    ["<C-left>"] = "<cmd>lua require('tmux').move_left()<cr>",
    ["<C-down>"] = "<Cmd>lua require('tmux').move_bottom()<CR>",
    ["<C-up>"] = "<Cmd>lua require('tmux').move_top()<CR>",
    ["<C-right>"] = "<Cmd>lua require('tmux').move_right()<CR>",
  },
  [""] = {
    -- moving splits
    ["<C-S-left>"] = "<C-W>H",
    ["<C-S-down>"] = "<C-W>J",
    ["<C-S-up>"] = "<C-W>K",
    ["<C-S-right>"] = "<C-W>L",
    -- resizing splits
    ["<A-left>"] = "<Cmd>silent lua require('tmux').resize_left()<CR>",
    ["<A-down>"] = "<Cmd>silent lua require('tmux').resize_bottom()<CR>",
    ["<A-up>"] = "<Cmd>silent lua require('tmux').resize_top()<CR>",
    ["<A-right>"] = "<Cmd>silent lua require('tmux').resize_right()<CR>",
    -- moving between splits
    ["<C-left>"] = "<cmd>silent lua require('tmux').move_left()<cr>",
    ["<C-down>"] = "<Cmd>silent lua require('tmux').move_bottom()<CR>",
    ["<C-up>"] = "<Cmd>silent lua require('tmux').move_top()<CR>",
    ["<C-right>"] = "<Cmd>silent lua require('tmux').move_right()<CR>",
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
