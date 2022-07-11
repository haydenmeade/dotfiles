local M = {}

local keymappings = {
  i = {},
  n = {
    j = "gj",
    k = "gk",
    ["<c-\\>"] = "<cmd>lua require('config.tmux').toggle_term()<cr>",
    ["<leader>rc"] = '<cmd>lua require("refactoring").debug.cleanup({})<CR>',
    ["<leader>ri"] = [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  },
  v = {
    ["C-s"] = "zy<Cmd>Telescope live_grep default_text=<C-r>z<cr>",

    ["<leader>ra"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    ["<leader>re"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    ["<leader>rh"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    ["<leader>rk"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
    ["<leader>rj"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
    -- Refactoring print
    ["<leader>rp"] = '<cmd>lua require("refactoring").debug.print_var({})<CR>',
  },
  t = {
    ["<esc>"] = [[<C-\><C-n>]],
    -- moving splits
    ["<C-S-left>"] = "<C-W>H",
    ["<C-S-down>"] = "<C-W>J",
    ["<C-S-up>"] = "<C-W>K",
    ["<C-S-right>"] = "<C-W>L",
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
    ["<C-left>"] = "<cmd>KittyNavigateLeft<cr>",
    ["<C-down>"] = "<Cmd>KittyNavigateDown<CR>",
    ["<C-up>"] = "<Cmd>KittyNavigateUp<CR>",
    ["<C-right>"] = "<Cmd>KittyNavigateRight<CR>",
  },
}

function M.setup()
  local opts = { noremap = true, silent = true, expr = false }
  for mode, mapping in pairs(keymappings) do
    for keys, cmd in pairs(mapping) do
      vim.api.nvim_set_keymap(mode, keys, cmd, opts)
    end
  end
  vim.keymap.set("n", "<leader>r", function()
    return ":IncRename " .. vim.fn.expand "<cword>"
  end, { expr = true })
end

M.setup()
