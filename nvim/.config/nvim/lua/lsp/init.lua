vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    require("config.lsp_keymap").register_lsp(bufnr)
  end,
})

vim.diagnostic.config({
  signs = { priority = 9999 },
  underline = true,
  update_in_insert = false,
  virtual_text = { current_line = true, severity = { min = "INFO", max = "WARN" } },
  virtual_lines = { current_line = true, severity = { min = "ERROR" } },
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
  },
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('jsonls')
vim.lsp.enable('yamlls')
vim.lsp.enable('bashls')
vim.lsp.enable('buf_ls')

require('lspkind').setup({})
