local M = {}

function M.config()
  --https://github.com/jose-elias-alvarez/typescript.nvim
  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts" },
    callback = function()
      -- local typescript = require "typescript"
      vim.cmd("TypescriptRemoveUnused")
      -- vim.cmd "TypescriptAddMissingImports"
      -- vim.cmd "TypescriptOrganizeImports"
      -- vim.cmd "TypescriptFixAll"
    end,
  })
  local capabilities = require("lsp").common_capabilities()
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }

  return {
    require("typescript").setup({
      disable_commands = false, -- prevent the plugin from creating Vim commands
      disable_formatting = true, -- disable tsserver's formatting capabilities
      debug = false, -- enable debug logging for commands
      server = { -- pass options to lspconfig's setup method
        logVerbosity = "normal",
        init_options = { hostInfo = "neovim" },
        capabilities = capabilities,
        on_attach = require("lsp").common_on_attach,
        flags = { debounce_text_changes = 150 },
      },
    }),
  }
end

return M
