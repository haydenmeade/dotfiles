---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  root_markers = { '.git' },
  single_file_support = true,
  filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
  settings = {
     yaml = {
       schemas = {
         -- ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
       },
      format = {
        enable = false,
      },
      editor = {
        tabSize = 2,
      },
      hover = true,
      completion = true,
     },
   },
}
