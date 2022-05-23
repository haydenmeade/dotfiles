local M = {}

function M.config()
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.go" },
    callback = function()
      vim.cmd "GoImport"
    end,
  })
  return {
    lspconfig = {
      analyses = { unusedparams = true, unreachable = false },
      codelenses = { generate = true, gc_details = true, test = true, tidy = true },
      experimentalPostfixCompletions = true,
      gofumpt = false,
      formatting = false,
    },
  }
end

return M
