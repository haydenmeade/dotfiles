vim.g.loglevel = "info" -- "trace" | "debug" | "info" | "warn" | "error"

local core_modules = {
  "core.options",
  "core.util",
  "core.log",
  "core.autocmds",
  "core.global",
}

for _, module in ipairs(core_modules) do
  local ok, mod = pcall(require, module)
  if not ok then
    error("Error loading " .. module .. "\n\n" .. mod)
  end
end

require("impatient")

require("plugins").setup()
