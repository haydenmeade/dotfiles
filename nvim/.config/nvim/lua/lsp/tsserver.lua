local M = {}

function M.config()
  --https://github.com/jose-elias-alvarez/typescript.nvim
  return {
    require("typescript").setup {
      disable_commands = false, -- prevent the plugin from creating Vim commands
      disable_formatting = true, -- disable tsserver's formatting capabilities
      debug = true, -- enable debug logging for commands
      server = { -- pass options to lspconfig's setup method
        logVerbosity = "normal",
      },
    },
  }
end

return M
