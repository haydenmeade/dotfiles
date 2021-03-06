local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local util = require("config.luasnip.util")
local ai = require("luasnip.nodes.absolute_indexer")
local partial = require("luasnip.extras").partial

-- Conditions
local function not_in_function()
  return not util.is_in_function()
end

local in_test_func = {
  show_condition = util.is_in_test_function,
  condition = util.is_in_test_function,
}

local in_test_file = {
  show_condition = util.is_in_test_file,
  condition = util.is_in_test_file,
}

local in_func = {
  show_condition = util.is_in_function,
  condition = util.is_in_function,
}

local not_in_func = {
  show_condition = not_in_function,
  condition = not_in_function,
}


-- stylua: ignore start
return {
  -- Main
  ls.s(
    { trig = "main", name = "Main", dscr = "Create a main function" },
    fmta("func main() {\n\t<>\n}", ls.i(0)),
    not_in_func
  ),

  ls.s(
    { trig = "tr", name = "Test Run", dscr = "Create a test run definition" },
    fmta("t.Run(\"<desc>\", func(t *testing.T) { \n<tt> \n})", {
      desc = ls.i(1, "Description"),
      tt = ls.i(0, ""),
    }),
    in_func
  ),

  ls.s(
    { trig = "ifcall", name = "IF CALL", dscr = "Call a function and check the error" },
    fmt(
      [[
        {val}, {err1} := {func}({args})
        if {err2} != nil {{
          return {err3}
        }}
        {finally}
      ]], {
      val     = ls.i(1, { "val" }),
      err1    = ls.i(2, { "err" }),
      func    = ls.i(3, { "Func" }),
      args    = ls.i(4),
      err2    = rep(2),
      err3    = ls.d(5, util.make_return_nodes, { 2 }),
      finally = ls.i(0),
    }),
    in_func
  ),

  ls.s(
    { trig = "f", name = "Function", dscr = "Create a function or a method" },
    fmt(
      [[
        // {name1} {desc}
        func {rec}{name2}({args}) {ret} {{
          {finally}
        }}
      ]], {
      name1   = rep(2),
      desc    = ls.i(5, "description"),
      rec     = ls.c(1, {
        ls.t(""),
        ls.sn(nil, fmt("({} {}) ", {
          ls.i(1, "r"),
          ls.i(2, "receiver"),
        })),
      }),
      name2   = ls.i(2, "Name"),
      args    = ls.i(3),
      ret     = ls.c(4, {
        ls.i(1, "error"),
        ls.sn(nil, fmt("({}, {}) ", {
          ls.i(1, "ret"),
          ls.i(2, "error"),
        })),
      }),
      finally = ls.i(0),
    })
  ),

  -- Append
  ls.s(
    { trig = "ap", dscr = "append to an array" },
    fmt(
      [[
        {arr1} = append({arr}, {var}) 
      ]], {
      arr1 = rep(1),
      arr = ls.i(1, "arr"),
      var = ls.i(0, "var"),
    }),
    in_func
  ),

  -- If error
  ls.s(
    { trig = "ie", name = "If error", dscr = "If error, return wrapped" },
    fmt("if {} != nil {{\n\treturn {}\n}}\n{}", {
      ls.i(1, "err"),
      ls.d(2, util.make_return_nodes, { 1 }),
      ls.i(0),
    }),
    in_func
  ),

  -- gRPC Error
  ls.s(
    { trig = "gerr", dscr = "Return an instrumented gRPC error" },
    fmt('internal.GrpcError({},\n\tcodes.{}, "{}", "{}", {})', {
      ls.i(1, "err"),
      ls.i(2, "Internal"),
      ls.i(3, "Description"),
      ls.i(4, "Field"),
      ls.i(5, "fields"),
    }),
    in_func
  ),

  -- Mockery {{{
  ls.s(
    { trig = "mockery", name = "Mockery", dscr = "Create an interface for making mocks" },
    fmt(
      [[
        // {} mocks {} interface for testing purposes.
        //go:generate mockery --name {} --filename {}_mock.go
        type {} interface {{
          {}
        }}
      ]], {
      rep(1),
      rep(2),
      rep(1),
      ls.f(function(args) return util.snake_case(args[1][1]) end, { 1 }),
      ls.i(1, "Client"),
      ls.i(2, "pkg.Interface"),
    })
  ), --}}}

  -- Nolint {{{
  ls.s(
    { trig = "nolint", dscr = "ignore linter" },
    fmt([[// nolint:{} // {}]], {
      ls.i(1, "names"),
      ls.i(2, "explaination"),
    })
  ), --}}}

  -- Allocate Slices and Maps {{{
  ls.s(
    { trig = "m", name = "Make", dscr = "Allocate map or slice" },
    fmt("{} {}= make({})\n{}", {
      ls.i(1, "name"),
      ls.i(2),
      ls.c(3, {
        fmt("[]{}, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("[]{}, 0, {}", { ls.i(1, "type"), ls.i(2, "len") }),
        fmt("map[{}]{}, {}", { ls.i(1, "keys"), ls.i(2, "values"), ls.i(3, "len") }),
      }),
      ls.i(0),
    }),
    in_func
  ), --}}}

  -- Test Cases {{{
  ls.s(
    { trig = "tcs", dscr = "create test cases for testing" },
    fmta(
      [[
        tcs := map[string]struct {
        	<>
        } {
        	// Test cases here
        }
        for name, tc := range tcs {
        	tc := tc
        	t.Run(name, func(t *testing.T) {
        		<>
        	})
        }
      ]],
      { ls.i(1), ls.i(2) }
    ),
    in_test_func
  ), --}}}

  -- Go CMP {{{
  ls.s(
    { trig = "gocmp", dscr = "Create an if block comparing with cmp.Diff" },
    fmt(
      [[
        if diff := cmp.Diff({}, {}); diff != "" {{
        	t.Errorf("(-want +got):\\n%s", diff)
        }}
      ]], {
      ls.i(1, "want"),
      ls.i(2, "got"),
    }),
    in_test_func
  ), --}}}

  -- Create Mocks {{{
  ls.s(
    { trig = "mock", name = "Mocks", dscr = "Create a mock with defering assertion" },
    fmt("{} := &mocks.{}{{}}\ndefer {}.AssertExpectations(t)\n{}", {
      ls.i(1, "m"),
      ls.i(2, "Mocked"),
      rep(1),
      ls.i(0),
    }),
    in_test_func
  ), --}}}

  -- Require NoError {{{
  ls.s(
    { trig = "noerr", name = "Require No Error", dscr = "Add a require.NoError call" },
    ls.c(1, {
      ls.sn(nil, fmt("require.NoError(t, {})", { ls.i(1, "err") })),
      ls.sn(nil, fmt('require.NoError(t, {}, "{}")', { ls.i(1, "err"), ls.i(2) })),
      ls.sn(nil, fmt('require.NoErrorf(t, {}, "{}", {})', { ls.i(1, "err"), ls.i(2), ls.i(3) })),
    }),
    in_test_func
  ), --}}}

  -- Subtests
  ls.s(
    { trig = "Test", name = "Test/Subtest", dscr = "Create subtests and their function stubs" },
    fmta("func <>(t *testing.T) {\n<>\n}\n\n <>", {
      ls.i(1),
      ls.d(2, util.create_t_run, ai({ 1 })),
      ls.d(3, util.mirror_t_run_funcs, ai({ 2 })),
    }),
    in_test_file
  ),

  -- Stringer
  ls.s(
    { trig = "stringer", name = "Stringer", dscr = "Create a stringer go:generate" },
    fmt("//go:generate stringer -type={} -output={}_string.go", {
      ls.i(1, "Type"),
      partial(vim.fn.expand, "%:t:r"),
    })
  ),

}
-- stylua: ignore end

-- vim: fdm=marker fdl=0
