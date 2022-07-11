local M = {}

function M.config()
  -- https://github.com/hrsh7th/vscode-langservers-extracted

  vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.ts" },
    callback = function()
      vim.cmd("EslintFixAll")
    end,
  })
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
