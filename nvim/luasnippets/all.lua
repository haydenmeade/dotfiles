local ls = require("luasnip")
local util = require("config.luasnip.util")
local partial = require("luasnip.extras").partial

return {
	ls.s("time", partial(vim.fn.strftime, "%H:%M:%S")),
	ls.s("date", partial(vim.fn.strftime, "%Y-%m-%d")),
	ls.s("pwd", { partial(util.shell, "pwd") }),
	ls.s("file", { partial(vim.fn.expand, "%") }),
	ls.s({ trig = "uuid", wordTrig = true }, { ls.f(util.uuid), ls.i(0) }),
	ls.s({ trig = "rstr(%d+)", regTrig = true }, {
		ls.f(function(_, snip)
			return util.random_string(snip.captures[1])
		end),
		ls.i(0),
	}),
}
