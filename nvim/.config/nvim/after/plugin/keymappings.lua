local util = require("core.util")

local M = {}
local leader_mappings = {
  w = "<Cmd>w!<Cr>",
  q = "<Cmd>q!<Cr>",
  x = "<Cmd>x!<Cr>",
  X = "<Cmd>wqall!<Cr>",
  o = "<Cmd>%bd|e#|bd#<Cr>",
  c = "<Cmd>bdelete<Cr>",
  f = "<cmd>lua require('config.telescope').find_project_files()<CR>",
  F = "<cmd>lua require('telescope.builtin').find_files(require('config.telescope').no_preview())<CR>",
  e = "<cmd>lua require('oil').open(vim.fn.expand('%:p:h'))<CR>",
  h = "<cmd>nohlsearch<CR>",

  -- System
  z = {
    s = "<cmd>SaveSession<Cr>",
    l = "<cmd>SearchSession<Cr>",
    m = "<Cmd>messages<Cr>",
    M = "<Cmd>put =execute('messages')<Cr>",
    y = "<Cmd>lua require('lazy').sync()<CR>",
  },

  -- refactor
  r = {
    r = [[<cmd>lua require('grug-far').grug_far()<CR>]],
    c = [[<cmd>lua require('grug-far').grug_far({ prefills = { search = vim.fn.expand("<cword>") } })<CR>]],
    f = [[<cmd>lua require('grug-far').grug_far({ prefills = { flags = vim.fn.expand("%") } })<CR>]],
    C = '<cmd>lua require("refactoring").debug.cleanup({})<CR>',
    i = [[<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    g = [[<cmd>lua require('rgflow').open_blank()<cr>]],
  },

  m = {
    i = function()
      local harpoon = require("harpoon")
      harpoon:list():add()
    end,
    m = function()
      local harpoon = require("harpoon")
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end,
    y = function()
      local harpoon = require("harpoon")
      harpoon:list():select(1)
    end,
    h = function()
      local harpoon = require("harpoon")
      harpoon:list():select(2)
    end,

    e = function()
      local harpoon = require("harpoon")
      harpoon:list():select(3)
    end,

    a = function()
      local harpoon = require("harpoon")
      harpoon:list():select(4)
    end,

    ["."] = function()
      local harpoon = require("harpoon")
      harpoon:list():select(5)
    end,
  },

  -- GitHub
  i = {
    a = "<Cmd>Octo pr list<Cr>",
    s = "<Cmd>Octo search assignee:haydenmeade is:pr<Cr>",
  },

  -- Search
  s = {
    b = "<Cmd>Telescope buffers<Cr>",
    q = "<Cmd>Telescope quickfix<Cr>",
    t = "<cmd>Telescope live_grep<CR>",
    n = "<Cmd>Telescope grep_string<Cr>",
    r = "<cmd>lua require('telescope.builtin').resume()<cr>",
  },

  -- Buffers
  b = {
    q = "<cmd>bd<cr>",
  },
  -- Git
  g = {
    d = "<Cmd>DiffviewOpen<Cr>",
    q = "<Cmd>DiffviewClose<Cr>",
    h = "<Cmd>DiffviewFileHistory %<Cr>",
    n = "<Cmd>Neogit<Cr>",
    j = "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
    k = "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
    l = "<cmd>lua require 'gitsigns'.blame_line()<cr>",
    p = "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
    r = "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
    R = "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
    s = "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
    u = "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
  },

  -- Testing
  t = {
    -- n = "<Cmd>w<CR><cmd>lua require('neotest').run.run()<CR>",
    -- n = "<Cmd>w<CR><cmd>TestNearest<CR>",
    --f = "<Cmd>w<CR><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
    -- f = "<Cmd>w<CR><cmd>TestFile<CR>",
    --o = "<cmd>lua require('neotest').output.open({ open_win = function() vim.cmd('vsplit') end })<CR>",
    --t = "<cmd>lua require('neotest').summary.toggle()<CR>",
    c = "<cmd>Coverage<CR>",
    y = "<cmd>CoverageSummary<CR>",
  },

  -- Trouble
  n = {
    n = "<Cmd>Trouble<CR>",
    d = "<Cmd>Trouble diagnostics<CR>",
    y = "<Cmd>Trouble quickfix<CR>",
    s = "<Cmd>Trouble symbols<CR>",
    r = "<Cmd>Trouble lsp_references<CR>",
    j = "<Cmd>lua require('trouble').previous({skip_groups=true,jump=true})<CR>",
    k = "<Cmd>lua require('trouble').next({skip_groups=true,jump=true})<CR>",
  },
}

-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
local keymappings = {
  i = {},
  n = {
    j = "gj",
    k = "gk",
    n = "nzzzv",
    N = "Nzzzv",
    ["CTRL-d"] = "<CTRL-d>zz",
    ["CTRL-u"] = "<CTRL-u>zz",
    [",s"] = "<Cmd>split<Cr>",
    [",v"] = "<Cmd>vs<Cr>",
    -- moving splits
    ["<CTRL-S-kLeft>"] = "<CTRL-W>H",
    ["<CTRL-S-kDown>"] = "<CTRL-W>J",
    ["<CTRL-S-up>"] = "<CTRL-W>K",
    ["<CTRL-S-kRight>"] = "<CTRL-W>L",
    -- resizing splits
    ["<A-left>"] = "<Cmd>lua require('smart-splits').resize_left(5)<CR>",
    ["<A-down>"] = "<Cmd>lua require('smart-splits').resize_down(5)<CR>",
    ["<A-up>"] = "<Cmd>lua require('smart-splits').resize_up(5)<CR>",
    ["<A-right>"] = "<Cmd>lua require('smart-splits').resize_right(5)<CR>",
  },
  v = {
    ["J"] = "<esc><cmd>m  '>+1<CR>gv=gv",
    ["K"] = "<esc><cmd>m  '>-2<CR>gv=gv",

    ["<leader>ra"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]],
    ["<leader>re"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]],
    ["<leader>rh"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]],
    ["<leader>rk"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Block')<CR>]],
    ["<leader>rj"] = [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]],
    -- Refactoring print
    ["<leader>rp"] = '<cmd>lua require("refactoring").debug.print_var({})<CR>',
  },
  t = {
    ["<esc>"] = [[<CTRL-\><CTRL-n>]],
    -- moving splits
    ["<CTRL-S-left>"] = "<CTRL-W>H",
    ["<CTRL-S-down>"] = "<CTRL-W>J",
    ["<CTRL-S-up>"] = "<CTRL-W>K",
    ["<CTRL-S-right>"] = "<CTRL-W>L",
  },
  x = {
    ["<leader>p"] = [["_dP]],
  },
  [""] = {

  },
}

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
  [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<CTRL-u>call g:VSetSearch('/')<CR>/<CTRL-R>=@/<CR><CR>
  xnoremap # :<CTRL-u>call g:VSetSearch('?')<CR>?<CTRL-R>=@/<CR><CR>
]],
  false
)

function M.setup()
  util.createmap("n", leader_mappings, "<leader>")
  for mode, mapping in pairs(keymappings) do
    util.createmap(mode, mapping)
  end
  vim.keymap.set({ "n" }, "<CTRL-k>", function()
    require("lsp_signature").toggle_float_win()
  end, { silent = true, noremap = true, desc = "toggle signature" })
end

M.setup()
