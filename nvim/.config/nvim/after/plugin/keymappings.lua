local util = require("core.util")

local M = {}
local leader_mappings = {
  w = "<Cmd>w!<Cr>",
  q = "<Cmd>q!<Cr>",
  x = "<Cmd>x!<Cr>",
  X = "<Cmd>wqall!<Cr>",
  o = "<Cmd>%bd|e#|bd#<Cr>",
  c = "<Cmd>bdelete<Cr>",
  C = "<cmd>Telescope file_create<CR>",
  f = "<cmd>lua require('config.telescope').find_project_files()<CR>",
  F = "<cmd>lua require('config.telescope').live_grep_in_glob()<CR>",
  E = "<cmd>Telescope file_browser<CR>",
  e = "<Cmd>NvimTreeToggle<CR>",
  h = "<cmd>nohlsearch<CR>",

  -- System
  z = {
    s = "<cmd>SaveSession<Cr>",
    l = "<cmd>SearchSession<Cr>",
    m = "<Cmd>messages<Cr>",
    M = "<Cmd>put =execute('messages')<Cr>",
    y = "<Cmd>lua require('core.util').update_packer()<CR>",
  },

  -- refactor
  r = {
    c = '<cmd>lua require("refactoring").debug.cleanup({})<CR>',
    i = [[<Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
  },

  m = {
    i = "<Cmd>lua require('harpoon.mark').add_file()<Cr>",
    m = "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>",
    n = "<Cmd>lua require('harpoon.ui').nav_next()<CR>",
    t = "<Cmd>lua require('harpoon.ui').nav_prev()<CR>",
    y = "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>",
    h = "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>",
    e = "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>",
    a = "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>",
    ["."] = "<Cmd>lua require('harpoon.ui').nav_file(5)<CR>",
  },

  -- GitHub
  i = {
    a = "<Cmd>Octo pr list<Cr>",
    s = "<Cmd>Octo search assignee:haydenmeade is:pr<Cr>",
  },

  -- Search
  s = {
    c = "<Cmd>Telescope current_buffer_fuzzy_find<CR>",
    b = "<Cmd>Telescope buffers<Cr>",
    g = "<Cmd>lua require('config.telescope').search_gopath()<CR>",
    l = "<Cmd>Telescope luasnip<CR>",
    t = "<Cmd>Telescope live_grep<Cr>",
    N = "<Cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<Cr>",
    n = "<Cmd>Telescope grep_string<Cr>",
    h = "<Cmd>Telescope help_tags<Cr>",
    m = "<Cmd>Telescope marks<Cr>",
    y = "<Cmd>Telescope symbols<Cr>",
    s = "<Cmd>Telescope<CR>",
    f = "<cmd>Telescope find_files<cr>",
    M = "<cmd>Telescope man_pages<cr>",
    r = "<cmd>Telescope oldfiles<cr>",
    R = "<cmd>Telescope registers<cr>",
    k = "<cmd>Telescope keymaps<cr>",
    C = "<cmd>Telescope commands<cr>",
    p = "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
  },

  -- Git
  g = {
    a = "<Cmd>Telescope repo list<Cr>",
    g = "<Cmd>lua require('config.toggleterm').lazygit_toggle()<Cr>",
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
    o = "<cmd>Telescope git_status<cr>",
    b = "<cmd>Telescope git_branches<cr>",
    c = "<cmd>Telescope git_commits<cr>",
    C = "<cmd>Telescope git_bcommits<cr>",
  },

  -- Testing
  t = {
    n = "<Cmd>w<CR><cmd>lua require('neotest').run.run()<CR>",
    N = "<Cmd>w<CR><cmd>TestNearest<CR>",
    f = "<Cmd>w<CR><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>",
    F = "<Cmd>w<CR><cmd>TestFile<CR>",
    o = "<cmd>lua require('neotest').output.open({ open_win = function() vim.cmd('vsplit') end })<CR>",
    t = "<cmd>lua require('neotest').summary.toggle()<CR>",
    c = "<cmd>Coverage<CR>",
    y = "<cmd>CoverageSummary<CR>",
  },

  -- Trouble
  n = {
    n = "<Cmd>TroubleToggle<CR>",
    w = "<Cmd>TroubleToggle workspace_diagnostics<CR>",
    d = "<Cmd>TroubleToggle document_diagnostics<CR>",
    y = "<Cmd>TroubleToggle quickfix<CR>",
    l = "<Cmd>TroubleToggle loclist<CR>",
    r = "<Cmd>TroubleToggle lsp_references<CR>",
    j = "<Cmd>lua require('trouble').previous({skip_groups=true,jump=true})<CR>",
    k = "<Cmd>lua require('trouble').next({skip_groups=true,jump=true})<CR>",
  },
}

local keymappings = {
  i = {},
  n = {
    j = "gj",
    k = "gk",
    [",s"] = { "<Cmd>split<Cr>", "Horizontal spit" },
    [",v"] = { "<Cmd>vs<Cr>", "Vertical Split" },
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

-- makes * and # work on visual mode too.
vim.api.nvim_exec(
  [[
  function! g:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
  endfunction

  xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
  xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
  false
)

function M.setup()
  util.createmap("n", leader_mappings, "<leader>")
  for mode, mapping in pairs(keymappings) do
    util.createmap(mode, mapping)
  end
end

M.setup()
