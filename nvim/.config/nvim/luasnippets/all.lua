local ls = require("luasnip")
local utils = require("go.utils")
local partial = require("luasnip.extras").partial

ls.add_snippets("all", {
  ls.s("time", partial(vim.fn.strftime, "%H:%M:%S")),
  ls.s("date", partial(vim.fn.strftime, "%Y-%m-%d")),
  ls.s("timestamp", partial(vim.fn.strftime, "%Y-%m-%d %H:%M:%S")),
  ls.s("rfc3339", partial(vim.fn.strftime, "%Y-%m-%dT%H:%M:%SZ")),
  ls.s("pwd", { partial(utils.run_command, "pwd") }),
  ls.s("tsf", ls.t("2006-01-02T15:04:05Z07:00")),
  ls.s("hlc", ls.t("http://localhost")),
  ls.s("hl1", ls.t("http://127.0.0.1")),
  ls.s("lh", ls.t("localhost")),
  ls.s("lh1", ls.t("127.0.0.1")),
  ls.s({ trig = "uid", wordTrig = true }, { ls.f(utils.uuid), ls.i(0) }),
  ls.s({ trig = "rstr(%d+)", regTrig = true }, {
    ls.f(function(_, snip)
      return utils.random_string(snip.captures[1])
    end),
    ls.i(0),
  }),
  ls.s(
    { trig = "lor", name = "Lorem Ipsum (Choice)", dscr = "Choose next for more lines" },
    ls.c(1, { ls.t(utils.random_line()), ls.t(utils.random_line()) })
  ),
  ls.s(
    {
      trig = "lor(%d+)",
      name = "Lorem Ipsum",
      regTrig = true,
      dscr = "Start with a count for lines",
    },
    ls.f(function(_, snip)
      local lines = snip.captures[1]
      if not tonumber(lines) then
        lines = 1
      end
      local lor = vim.split(utils.lorem(), ", ")
      return vim.list_slice(lor, lines)
    end)
  ),
})
