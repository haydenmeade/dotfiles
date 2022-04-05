local M = {}

function M.setup()
  require("indent_blankline").setup {

    show_current_context = true,
    show_current_context_start = true,
    space_char_blankline = " ",
    buftype_exclude = { "terminal" },
    filetype_exclude = { "NvimTree", "neo-tree", "help", "startify", "packer", "lsp-installer" },
  }
end
return M
