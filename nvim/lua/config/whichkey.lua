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

local mappings = {
  w = { "<Cmd>w!<Cr>", "Save" },
  q = { "<Cmd>q!<Cr>", "Quit" },
  x = { "<Cmd>x!<Cr>", "Save+Quiet" },
  c = { "<cmd>BufferKill<CR>", "Kill Buffer" },
  f = { "<cmd>lua require('config.telescope').find_project_files()<CR>", "Find File" },
  F = { "<cmd>lua require('config.telescope').live_grep_in_glob()<CR>", "Grep With FT Glob" },
  p = { "<cmd>lua require('session-lens').search_session()<CR>", "Switch Session" },
  e = { "<Cmd>NvimTreeToggle<CR>", "Explorer" },
  h = { "<cmd>nohlsearch<CR>", "No Highlight" },

  -- System
  z = {
    name = "System",
    b = {
      "<Cmd>hi Normal ctermbg=none guibg=none<CR>",
      "Transparent background",
    },
    s = { "<cmd>SaveSession<Cr>", "Save session" },
    l = { "<cmd>SearchSession<Cr>", "Load session" },
    h = { "<Cmd>ToggleTerm<CR>", "New horizontal terminal" },
    t = { "<Cmd>terminal<CR>", "New terminal" },
    z = {
      "<Cmd>lua require('config.telescope').search_dotfiles()<CR>",
      "Configuration",
    },
    m = { "<Cmd>messages<Cr>", "Messages" },
    c = { "<Cmd>put =execute('messages')<Cr>", "Put Messages" },
    p = { "<Cmd>messages clear<Cr>", "Clear messages" },
    f = { "<Cmd>FloatermNew<Cr>", "Floating terminal" },
    -- y = { "<Cmd>PackerSync<Cr>", "Packer update" },
    y = { "<Cmd>lua require('core.util').update_packer()<CR>", "Update packer" },
  },

  -- Buffer
  b = {
    name = "Buffer",
    a = { "<Cmd>BWipeout other<Cr>", "Delete all buffers" },
    d = { "<Cmd>bd<Cr>", "Delete current buffer" },
    n = { "<Cmd>bn<Cr>", "Next buffer" },
    p = { "<Cmd>bp<Cr>", "Previous buffer" },
    x = { "<Cmd>xa!<Cr>", "Save all & quit" },
    r = { "<Cmd>e!<CR>", "Reload file" },
    c = { "<Cmd>ene <BAR> startinsert <Cr>", "Create file" },
    j = { "<cmd>BufferLinePick<cr>", "Jump" },
    f = { "<cmd>Telescope buffers<cr>", "Find" },
    b = { "<cmd>BufferLineCyclePrev<cr>", "Previous" },
    -- w = { "<cmd>BufferWipeout<cr>", "Wipeout" }, -- TODO: implement this for bufferline
    e = {
      "<cmd>BufferLinePickClose<cr>",
      "Pick which buffer to close",
    },
    h = { "<cmd>BufferLineCloseLeft<cr>", "Close all to the left" },
    l = {
      "<cmd>BufferLineCloseRight<cr>",
      "Close all to the right",
    },
    D = {
      "<cmd>BufferLineSortByDirectory<cr>",
      "Sort by directory",
    },
    L = {
      "<cmd>BufferLineSortByExtension<cr>",
      "Sort by language",
    },
  },

  -- Quick fix
  -- c = {
  -- 	name = "Quickfix",
  -- 	o = { "<Cmd>copen<Cr>", "Open quickfix" },
  -- 	c = { "<Cmd>cclose<Cr>", "Close quickfix" },
  -- 	n = { "<Cmd>cnext<Cr>", "Next quickfix" },
  -- 	p = { "<Cmd>cprev<Cr>", "Previous quickfix" },
  -- 	x = { "<Cmd>cex []<Cr>", "Clear quickfix" },
  -- 	t = { "<Cmd>BqfAutoToggle<Cr>", "Toggle preview" },
  -- },

  -- Search
  s = {
    name = "Search",
    c = { "<Cmd>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy find buffer" },
    b = { "<Cmd>Telescope buffers<Cr>", "Search buffers" },
    l = { "<Cmd>Telescope luasnip<CR>", "Search snippets" },
    t = { "<Cmd>Telescope live_grep<Cr>", "Live grep" },
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
      "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
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
    g = { "<Cmd>Git<Cr>", "Git status" },
    d = { "<Cmd>Gvdiffsplit<Cr>", "Git diff" },
    f = { "<Cmd>Git fetch --all<Cr>", "Git fetch" },
    m = { "<Cmd>GitMessenger<Cr>", "Git messenger" },
    n = { "<Cmd>Neogit<Cr>", "NeoGit" },
    v = { "<Cmd>DiffviewOpen<Cr>", "Diffview open" },
    q = { "<Cmd>DiffviewClose<Cr>", "Diffview close" },
    h = { "<Cmd>DiffviewFileHistory<Cr>", "File history" },
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
    n = { "<Cmd>w<CR><cmd>UltestNearest<CR>", "Test nearest" },
    f = { "<Cmd>w<CR><cmd>Ultest<CR>", "Test file" },
    o = { "<Cmd>w<CR><cmd>UltestOutput<CR>", "Test output" },
    l = { "<Cmd>w<CR><cmd>UltestLast<CR>", "Test last" },
    v = { "<Cmd>w<CR><cmd>TestVisit<CR>", "Test visit" },
    d = { "<Cmd>w<CR><cmd>UltestDebug<CR>", "Test debug" },
    g = { "<Cmd>w<CR><cmd>UltestDebugNearest<CR>", "Test debug nearest" },
    t = { "<Cmd>w<CR><cmd>UltestSummary<CR>", "Test summary" },
    c = { "<Cmd>w<CR><cmd>UltestClear<CR>", "Test clear" },
    s = { "<Cmd>w<CR><cmd>UltestStop<CR>", "Test stop" },
  },

  -- Run
  r = {
    name = "Run",
    x = "Swap next parameter",
    X = "Swap previous parameter",
    s = { "<Cmd>SnipRun<CR>", "Run snippets" },
  },

  -- Notes
  n = {
    name = "Notes",
    n = {
      "<Cmd>FloatermNew nvim ~/notes/<Cr>",
      "New note",
    },
    o = { "<Cmd>GkeepOpen<Cr>", "GKeep Open" },
    c = { "<Cmd>GkeepClose<Cr>", "GKeep Close" },
    r = { "<Cmd>GkeepRefresh<Cr>", "GKeep Refresh" },
    s = { "<Cmd>GkeepSync<Cr>", "GKeep Sync" },
    p = { "<Cmd>MarkdownPreview<Cr>", "Preview markdown" },
    z = { "<Cmd>ZenMode<Cr>", "Zen Mode" },
    g = { "<Cmd>GrammarousCheck<Cr>", "Grammar check" },
  },
}

local no_leader_mappings = {
  -- ["<M-left>"] = "<C-w>>",
  -- ["<M-right>"] = "<C-w><",
  -- ["<M-up>"] = "<C-w>+",
  -- ["<M-down>"] = "<C-w>-",
  [",h"] = { "<Cmd>wincmd h<Cr>", "Move left" },
  [",j"] = { "<Cmd>wincmd j<Cr>", "Move down" },
  [",l"] = { "<Cmd>wincmd l<Cr>", "Move Right" },
  [",k"] = { "<Cmd>wincmd k<Cr>", "Move Up" },
  [",s"] = { "<Cmd>split<Cr>", "Horizontal spit" },
  [",v"] = { "<Cmd>vs<Cr>", "Vertical Split" },
}

local lsp_mappings = {
  l = {
    name = "LSP",
    r = { "<Cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    u = { "<Cmd>Telescope lsp_references<CR>", "References" },
    o = { "<Cmd>Telescope lsp_document_symbols<CR>", "Document symbols" },
    d = { "<Cmd>Telescope lsp_definitions<CR>", "Definition" },
    a = { "<Cmd>Telescope lsp_code_actions<CR>", "Code actions" },
    e = { "<Cmd>lua vim.diagnostic.enable()<CR>", "Enable diagnostics" },
    x = { "<Cmd>lua vim.diagnostic.disable()<CR>", "Disable diagnostics" },
    n = { "<Cmd>lua require('core.autocmds').toggle_format_on_save()<CR>", "Toggle format on save" },
    t = { "<Cmd>TroubleToggle<CR>", "Trouble" },
    l = { "<Cmd>lua vim.lsp.codelens.refresh()<CR>", "Codelens refresh" },
    s = { "<Cmd>lua vim.lsp.codelens.run()<CR>", "Codelens run" },
    f = { "<Cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
    w = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
    j = {
      "<cmd>lua vim.diagnostic.goto_next()<cr>",
      "Next Diagnostic",
    },
    k = {
      "<cmd>lua vim.diagnostic.goto_prev()<cr>",
      "Prev Diagnostic",
    },
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

    -- Refactoring print
    P = { '<cmd>lua require("refactoring").debug.printf({below = false})<CR>', "Print" },
    C = { '<cmd>lua require("refactoring").debug.cleanup({})<CR>', "Clear print" },
  },
}

function M.register_dap()
  require("which-key").register(dap_nvim_dap_mappings, opts)
end

function M.register_lsp(client)
  local wk = require "which-key"
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
  local wk = require "which-key"
  wk.setup {
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
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^<cmd>", "^ " }, -- hide mapping boilerplate
      show_help = true, -- show help message on the command line when the popup is visible
    },
  }
  wk.register(mappings, opts)
  wk.register(no_leader_mappings, no_leader_opts)
end

return M
