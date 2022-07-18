local M = {}

function M.setup()
  local ok, _ = h.safe_require("nvim-treesitter")
  if not ok then
    return
  end

  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    -- List of parsers to ignore installing (for "all")
    ignore_install = { "php", "phpdoc" },
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<M-w>",
        node_incremental = "<M-w>",
        node_decremental = "<M-n>",
        scope_incremental = "<M-t>",
      },
    },
    indent = { enable = true },
    rainbow = { enable = true, extended_mode = true },
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["at"] = "@call.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
      swap = {
        enable = true,
        swap_next = { ["<Leader>rx"] = "@parameter.inner" },
        swap_previous = { ["<Leader>rX"] = "@parameter.inner" },
      },
      lsp_interop = {
        enable = true,
        border = "none",
        peek_definition_code = {},
      },
    },
    context_commentstring = { enable = true, enable_autocmd = false },
    matchup = { enable = true },
    endwise = {
      enable = true,
    },
  })
  require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 3, -- How many lines the window should span. Values <= 0 mean no limit.
  })
end

return M
