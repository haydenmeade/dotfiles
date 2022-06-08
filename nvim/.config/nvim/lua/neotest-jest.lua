local async = require "neotest.async"
local Path = require "plenary.path"
local lib = require "neotest.lib"

---@type neotest.Adapter
local adapter = { name = "neotest-jest" }

adapter.root = lib.files.match_root_pattern "package.json"

function adapter.is_test_file(file_path)
  return vim.endswith(file_path, ".test.ts")
end

---@async
---@return neotest.Tree | nil
function adapter.discover_positions(path)
  local query = [[
  ((call_expression
      function: (identifier) @func_name (#match? @func_name "^describe$")
      arguments: (arguments (_) @namespace.name (arrow_function))
  )) @namespace.definition


  ((call_expression
      function: (identifier) @func_name (#match? @func_name "^it$")
      arguments: (arguments (_) @test.name (arrow_function))
  ) ) @test.definition
    ]]
  return lib.treesitter.parse_positions(path, query, { nested_tests = true })
end

-- TODO
-- if filereadable('node_modules/.bin/jest')
--    return 'node_modules/.bin/jest'
--  else
--    return 'jest'
--  endif

---@param args neotest.RunArgs
---@return neotest.RunSpec | nil
function adapter.build_spec(args)
  local notify = require "notify"
  -- notify(vim.pretty_print(args))
  notify "build spec"
  local results_path = vim.fn.tempname()
  local tree = args.tree
  if not tree then
    return
  end
  local pos = args.tree:data()
  -- if pos.type == "dir" then
  --   return
  -- end
  -- local filters = {}
  -- if pos.type == "namespace" or pos.type == "test" then
  --   table.insert(filters, 1, { pos.range[1], pos.range[3] })
  --   for parent in tree:iter_parents() do
  --     local parent_pos = parent:data()
  --     if parent_pos.type ~= "namespace" then
  --       break
  --     end
  --     table.insert(filters, 1, { parent_pos.range[1], parent_pos.range[3] })
  --   end
  -- end

  local command = vim.tbl_flatten {
    "node_modules/.bin/jest",
    "--no-coverage",
    "--",
    pos.path,
  }
  return {
    command = command,
    context = {
      results_path = results_path,
      file = pos.path,
    },
  }
end

---@async
---@param spec neotest.RunSpec
---@param _ neotest.StrategyResult
---@param tree neotest.Tree
---@return neotest.Result[]
function adapter.results(spec, _, tree) end

setmetatable(adapter, {
  __call = function()
    return adapter
  end,
})

return adapter
-- TODO vim-test
-- if !exists('g:test#javascript#jest#file_pattern')
--   let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
-- endif
--
-- function! test#javascript#jest#test_file(file) abort
--   if a:file =~# g:test#javascript#jest#file_pattern
--       if exists('g:test#javascript#runner')
--           return g:test#javascript#runner ==# 'jest'
--       else
--         return test#javascript#has_package('jest')
--       endif
--   endif
-- endfunction
--
-- function! test#javascript#jest#build_position(type, position) abort
--   if a:type ==# 'nearest'
--     let name = s:nearest_test(a:position)
--     if !empty(name)
--       let name = '-t '.shellescape(name, 1)
--     endif
--     return ['--no-coverage', name, '--', a:position['file']]
--   elseif a:type ==# 'file'
--     return ['--no-coverage', '--', a:position['file']]
--   else
--     return []
--   endif
-- endfunction
--
-- let s:yarn_command = '\<yarn\>'
-- function! test#javascript#jest#build_args(args) abort
--   if exists('g:test#javascript#jest#executable')
--     \ && g:test#javascript#jest#executable =~# s:yarn_command
--     return filter(a:args, 'v:val != "--"')
--   else
--     return a:args
--   endif
-- endfunction
--
-- function! test#javascript#jest#executable() abort
--   if filereadable('node_modules/.bin/jest')
--     return 'node_modules/.bin/jest'
--   else
--     return 'jest'
--   endif
-- endfunction
--
-- function! s:nearest_test(position) abort
--   let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
--   return (len(name['namespace']) ? '^' : '') .
--        \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
--        \ (len(name['test']) ? '$' : '')
-- endfunction
