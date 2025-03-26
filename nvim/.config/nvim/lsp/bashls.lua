---@type vim.lsp.Config
return {
  cmd = { "bash-language-server", "start" },
  root_markers = { '.git' },
  single_file_support = true,
  filetypes = { "bash", "sh" },
}
