local M = {}

function M.config()
  -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  return {
    lspconfig = {
      experimentalPostfixCompletions = true,
      analyses = { unusedparams = true, unreachable = false },
      codelenses = { generate = true, gc_details = true, test = true, tidy = true },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      matcher = "fuzzy",
      experimentalDiagnosticsDelay = "500ms",
      symbolMatcher = "fuzzy",
      gofumpt = true,
    },
  }
end

return M
