local ls = require("luasnip")
local util = require("config.luasnip.util")
local partial = require("luasnip.extras").partial

return {
  ls.s("time", partial(vim.fn.strftime, "%H:%M:%S")),
  ls.s("date", partial(vim.fn.strftime, "%Y-%m-%d")),
  ls.s("pwd", { partial(util.shell, "pwd") }),
  ls.s("file", { partial(vim.fn.expand, "%") }),
  ls.s({ trig = "uuid", wordTrig = true }, { ls.f(util.uuid), ls.i(0) }),
}
