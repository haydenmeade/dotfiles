local M = {}

local no_leader_opts = {
  mode = "n",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
}

local opts = {
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
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

local mappings = {
  w = { "<Cmd>w!<Cr>", "Save" },
  q = { "<Cmd>q!<Cr>", "Quit" },
  x = { "<Cmd>x!<Cr>", "Save+Quit" },
  X = { "<Cmd>wqall!<Cr>", "Save+Quit all" },
  o = { "<Cmd>%bd|e#|bd#<Cr>", "Delete all buffers but current" },
  c = { "<Cmd>bdelete<Cr>", "Delete current buffer" },
  C = { "<cmd>Telescope file_create<CR>", "Create File" },
  f = { "<cmd>lua require('config.telescope').find_project_files()<CR>", "Find File" },
  F = { "<cmd>lua require('config.telescope').live_grep_in_glob()<CR>", "Grep With FT Glob" },
  E = { "<cmd>Telescope file_browser<CR>", "Telescope Explorer" },
  e = { "<Cmd>NvimTreeToggle<CR>", "NvimTree" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },
  -- Z = { [[<cmd>lua require("zen-mode").reset()<cr>]], "Zen Mode" },
  Z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },

  -- System
  z = {
    name = "System",
    s = { "<cmd>SaveSession<Cr>", "Save session" },
    l = { "<cmd>SearchSession<Cr>", "Load session" },
    m = { "<Cmd>messages<Cr>", "Messages" },
    M = { "<Cmd>put =execute('messages')<Cr>", "Put Messages" },
    y = { "<Cmd>lua require('core.util').update_packer()<CR>", "Update packer" },
  },

  m = {
    name = "Harpoon",
    i = { "<Cmd>lua require('harpoon.mark').add_file()<Cr>", "add mark" },
    m = { "<Cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", "view" },
    n = { "<Cmd>lua require('harpoon.ui').nav_next()<CR>", "next" },
    t = { "<Cmd>lua require('harpoon.ui').nav_prev()<CR>", "prev" },

    y = { "<Cmd>lua require('harpoon.ui').nav_file(1)<CR>", "1" },
    h = { "<Cmd>lua require('harpoon.ui').nav_file(2)<CR>", "2" },
    e = { "<Cmd>lua require('harpoon.ui').nav_file(3)<CR>", "3" },
    a = { "<Cmd>lua require('harpoon.ui').nav_file(4)<CR>", "4" },
    ["."] = { "<Cmd>lua require('harpoon.ui').nav_file(5)<CR>", "5" },
  },

  -- GitHub
  i = {
    name = "GitHub",
    a = { "<Cmd>Octo pr list<Cr>", "Search PR all" },
    s = { "<Cmd>Octo search assignee:haydenmeade is:pr<Cr>", "Search PR me" },
  },

  -- Search
  s = {
    name = "Search",
    c = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find buffer" },
    b = { "<Cmd>Telescope buffers<Cr>", "Search buffers" },
    g = { "<Cmd>lua require('config.telescope').search_gopath()<CR>", "Search GoPath Src" },
    l = { "<Cmd>Telescope luasnip<CR>", "Search snippets" },
    t = { "<Cmd>Telescope live_grep<Cr>", "Live grep" },
    N = { "<Cmd>lua require('telescope').extensions.live_grep_raw.live_grep_raw()<Cr>", "Raw grep" },
    n = { "<Cmd>Telescope grep_string<Cr>", "grep word under cursor" },
    h = { "<Cmd>Telescope help_tags<Cr>", "Help" },
    m = { "<Cmd>Telescope marks<Cr>", "Mark" },
    y = { "<Cmd>Telescope symbols<Cr>", "Symbols" },
    s = { "<Cmd>Telescope<CR>", "Telescope" },
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
    R = { "<cmd>Telescope registers<cr>", "Registers" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    C = { "<cmd>Telescope commands<cr>", "Commands" },
    p = {
      "<cmd>lua require('telescope.builtin').colorscheme({enable_preview = true})<cr>",
      "Colorscheme with Preview",
    },
    T = {
      name = "Treesitter",
      i = { "<cmd>TSConfigInfo<cr>", "Info" },
    },
  },

  -- Git
  g = {
    name = "Source code",
    a = { "<Cmd>Telescope repo list<Cr>", "All repositories" },
    g = { "<Cmd>lua require('config.toggleterm').lazygit_toggle()<Cr>", "Lazy git" },
    d = { "<Cmd>DiffviewOpen<Cr>", "Diffview open" },
    q = { "<Cmd>DiffviewClose<Cr>", "Diffview close" },
    h = { "<Cmd>DiffviewFileHistory %<Cr>", "File history" },
    n = { "<Cmd>Neogit<Cr>", "Neogit" },
    j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
    k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
    l = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    u = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
    C = {
      "<cmd>Telescope git_bcommits<cr>",
      "Checkout commit(for current file)",
    },
  },

  -- Testing
  t = {
    name = "Test",
    n = { "<Cmd>w<CR><cmd>lua require('neotest').run.run()<CR>", "Test nearest" },
    N = { "<Cmd>w<CR><cmd>TestNearest<CR>", "Test nearest" },
    f = { "<Cmd>w<CR><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", "Test file" },
    F = { "<Cmd>w<CR><cmd>TestFile<CR>", "Test file" },
    o = {
      "<cmd>lua require('neotest').output.open({ open_win = function() vim.cmd('vsplit') end })<CR>",
      "Test output",
    },
    v = { "<Cmd>w<CR><cmd>TestVisit<CR>", "Test visit" },
    t = { "<cmd>lua require('neotest').summary.toggle()<CR>", "Test summary" },
    c = { "<cmd>Coverage<CR>", "Coverage" },
    y = { "<cmd>CoverageSummary<CR>", "Coverage Summary" },
  },

  -- Run
  -- r = {
  --   name = "Run",
  --   x = "Swap next parameter",
  --   X = "Swap previous parameter",
  --   s = { "<Cmd>SnipRun<CR>", "Run snippets" },
  -- },

  -- Trouble
  n = {
    name = "Trouble",
    n = { "<Cmd>TroubleToggle<CR>", "Trouble" },
    w = { "<Cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Diagnostics" },
    d = { "<Cmd>TroubleToggle document_diagnostics<CR>", "Document Diagnostics" },
    y = { "<Cmd>TroubleToggle quickfix<CR>", "Quickfix" },
    l = { "<Cmd>TroubleToggle loclist<CR>", "Loclist" },
    r = { "<Cmd>TroubleToggle lsp_references<CR>", "References" },

    j = { "<Cmd>lua require('trouble').previous({skip_groups=true,jump=true})<CR>", "previous item" },
    k = { "<Cmd>lua require('trouble').next({skip_groups=true,jump=true})<CR>", "next item" },
  },
}

local no_leader_mappings = {
  [",s"] = { "<Cmd>split<Cr>", "Horizontal spit" },
  [",v"] = { "<Cmd>vs<Cr>", "Vertical Split" },
}

local lsp_mappings = {
  l = {
    name = "LSP",
    R = { "<Cmd>lua require('lsp.utils').RenameWithQuickfix()<CR>", "Rename with quickfix" },
    -- R = { "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    u = { "<Cmd>Telescope lsp_references<CR>", "References" },
    o = { "<Cmd>Telescope lsp_document_symbols<CR>", "Document symbols" },
    d = { "<Cmd>Telescope lsp_definitions<CR>", "Definition" },
    a = { "<Cmd>lua vim.lsp.buf.code_action()<CR>", "Code actions" },
    e = { "<Cmd>lua vim.diagnostic.open_float()<CR>", "Open diagnostics" },
    X = { "<Cmd>lua vim.diagnostic.enable()<CR>", "Enable diagnostics" },
    x = { "<Cmd>lua vim.diagnostic.disable()<CR>", "Disable diagnostics" },
    n = { "<Cmd>lua require('core.autocmds').toggle_format_on_save()<CR>", "Toggle format on save" },
    l = { "<Cmd>lua vim.lsp.codelens.refresh()<CR>", "Codelens refresh" },
    s = { "<Cmd>lua vim.lsp.codelens.run()<CR>", "Codelens run" },
    f = { "<Cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    S = {
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      "Workspace Symbols",
    },
  },
}

M.lsp_buffer_keymappings = {
  K = { "<Cmd>lua vim.lsp.buf.hover()<CR>", "Hover Definition" },
  g = {
    D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
    d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition" },
    i = { "<Cmd>lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
    r = { "<Cmd>lua vim.lsp.buf.references()<CR>", "Show all references" },
  },
  ["<C-k>"] = { "<Cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
  ["[d"] = { "<Cmd>lua vim.diagnostic.goto_prev()<CR>", "goto_prev diagnostic" },
  ["]d"] = { "<Cmd>lua vim.diagnostic.goto_next()<CR>", "goto_next diagnostic" },
}

local dap_nvim_dap_mappings = {
  d = {
    name = "DAP",
    b = { "<Cmd>lua require('dap').toggle_breakpoint()<CR>", "Toggle breakpoint" },
    c = { "<Cmd>lua require('dap').continue()<CR>", "Continue" },
    s = { "<Cmd>lua require('dap').step_over()<CR>", "Step over" },
    i = { "<Cmd>lua require('dap').step_into()<CR>", "Step into" },
    o = { "<Cmd>lua require('dap').step_out()<CR>", "Step out" },
    u = { "<Cmd>lua require('dapui').toggle()<CR>", "Toggle UI" },
    p = { "<Cmd>lua require('dap').repl.open()<CR>", "REPL" },
    e = { '<Cmd>lua require"telescope".extensions.dap.commands{}<CR>', "Commands" },
    f = { '<Cmd>lua require"telescope".extensions.dap.configurations{}<CR>', "Configurations" },
    r = { '<Cmd>lua require"telescope".extensions.dap.list_breakpoints{}<CR>', "List breakpoints" },
    v = { '<Cmd>lua require"telescope".extensions.dap.variables{}<CR>', "Variables" },
    m = { '<Cmd>lua require"telescope".extensions.dap.frames{}<CR>', "Frames" },
  },
}

function M.register_dap()
  require("which-key").register(dap_nvim_dap_mappings, opts)
end

function M.register_lsp(client)
  local wk = require("which-key")
  wk.register(lsp_mappings, opts)
  wk.register(M.lsp_buffer_keymappings, {
    mode = "n",
    buffer = client,
    silent = true,
    noremap = true,
    nowait = true,
  })
end

function M.setup()
  local ok, wk = h.safe_require("which-key")
  if not ok then
    return
  end
  wk.setup({
    setup = {
      plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
          operators = false, -- adds help for operators like d, y, ...
          motions = false, -- adds help for motions
          text_objects = false, -- help for text objects triggered after entering an operator
          windows = true, -- default bindings on <c-w>
          nav = true, -- misc bindings to work with windows
          z = true, -- bindings for folds, spelling and others prefixed with z
          g = true, -- bindings for prefixed with g
        },
        spelling = { enabled = true, suggestions = 20 }, -- use which-key for spelling hints
      },
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    },
  })
  wk.register(mappings, opts)
  wk.register(no_leader_mappings, no_leader_opts)
end

return M
