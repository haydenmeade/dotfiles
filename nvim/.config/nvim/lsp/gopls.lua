---@type vim.lsp.Config
return {
    cmd = { "gopls" },
    root_markers = { "go.work", "go.mod", ".git" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
    settings = {
      analyses = { unusedparams = true, unreachable = false },
      gofumpt = false,
      formatting = false,
    },
}
