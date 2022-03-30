local M = {}

function M.config()
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  return {
    lspconfig = {
      analyses = { unusedparams = true, unreachable = false },
      codelenses = { generate = true, gc_details = true, test = true, tidy = true },
      experimentalPostfixCompletions = true,
      gofumpt = false,
    },
  }
end

return M
