local M = {}

function M.config()
  -- https://github.com/hrsh7th/vscode-langservers-extracted
  return {
    {
      codeAction = {
        disableRuleComment = {
          enable = true,
          location = "separateLine",
        },
        showDocumentation = {
          enable = true,
        },
      },
      codeActionOnSave = {
        enable = false,
        mode = "all",
      },
      format = false,
      quiet = false,
      rulesCustomizations = {},
      validate = "on",
    },
  }
end

return M
