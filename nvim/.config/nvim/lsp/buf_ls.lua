---@type vim.lsp.Config
return {
  cmd = { "buf", "beta", "lsp", "--timeout=0", "--log-format=text" },
  root_markers = { '.git' },
  filetypes = { "proto" },
}
