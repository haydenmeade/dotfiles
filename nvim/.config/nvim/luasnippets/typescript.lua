local ls = require "luasnip"
local fmt = require("luasnip.extras.fmt").fmt
local util = require "config.luasnip.util"

return {
  ls.s(-- logger.log {{{
    { trig = "l", dsce = "logger.log something" },
    fmt([[ logger.{}}({}) ]], {
      ls.c(1, {
        ls.t "info",
        ls.t "warn",
        ls.t "error",
      }),
      ls.i(0),
    })
  ), --}}}
}
