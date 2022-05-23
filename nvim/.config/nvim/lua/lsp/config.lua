return {
  diagnostics = {
    signs = {
      active = true,
      values = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
    },
    virtual_text = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
      format = function(d)
        local t = vim.deepcopy(d)
        local code = d.code or (d.user_data and d.user_data.lsp.code)
        if code then
          t.message = string.format("%s [%s]", t.message, code):gsub("1. ", "")
        end
        return t.message
      end,
    },
  },
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
}
