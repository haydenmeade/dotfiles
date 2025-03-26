vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    require("lsp_signature").on_attach({}, bufnr)
    require("config.lsp_keymap").register_lsp(bufnr)
  end,
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('jsonls')
vim.lsp.enable('yamlls')
vim.lsp.enable('bashls')
vim.lsp.enable('buf_ls')
