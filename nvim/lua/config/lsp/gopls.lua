local M = {}

local lsputils = require "config.lsp.utils"

function M.config(installed_server)
  return {
    lspconfig = {
      capabilities = lsputils.get_capabilities(),
      on_attach = lsputils.lsp_attach,
      on_init = lsputils.lsp_init,
      on_exit = lsputils.lsp_exit,
      cmd_env = installed_server._default_options.cmd_env,
      flags = { debounce_text_changes = 150 },
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
      buildFlags = { "-tags", "integration" },
    },
  }
end

function M.setup(installed_server)
  return M.config(installed_server)
end

return M
