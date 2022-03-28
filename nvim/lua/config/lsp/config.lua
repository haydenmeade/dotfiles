-- DATA_PATH = vim.fn.stdpath "data"
---@return string
local function get_runtime_dir()
  return vim.fn.stdpath "data"
end
return {
  templates_dir = join_paths(get_runtime_dir(), "site", "after", "ftplugin"),
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
    update_in_insert = false,
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
  document_highlight = true,
  code_lens_refresh = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
  },
  on_attach_callback = nil,
  on_init_callback = nil,
  automatic_servers_installation = true,
  buffer_mappings = {
    normal_mode = {},
    insert_mode = {},
    visual_mode = {},
  },
  null_ls = {
    setup = {},
    config = {},
  },
  override = {
    "angularls",
    "ansiblels",
    "ccls",
    "csharp_ls",
    "cssmodules_ls",
    "denols",
    "ember",
    "emmet_ls",
    "eslint",
    "eslintls",
    "golangci_lint_ls",
    "grammarly",
    "graphql",
    "ltex",
    "ocamllsp",
    "phpactor",
    "psalm",
    "pylsp",
    "quick_lint_js",
    "reason_ls",
    "remark_ls",
    "rome",
    "scry",
    "solang",
    "solidity_ls",
    "sorbet",
    "sourcekit",
    "spectral",
    "sqlls",
    "sqls",
    "stylelint_lsp",
    "tailwindcss",
    "tflint",
    "verible",
    "vuels",
    "zeta_note",
    "zk",
  },
}
