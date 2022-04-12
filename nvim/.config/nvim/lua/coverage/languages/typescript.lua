local M = {}

local config = require "coverage.config"
local local_util = require "coverage.local_util"
local python = require "coverage.languages.python"

--- Loads a coverage report.
-- This method should perform whatever steps are necessary to generate a coverage report.
-- The coverage report results should passed to the callback, which will be cached by the plugin.
-- @param callback called with results of the coverage report
M.load = function(callback)
  local_util.lcov_load(callback, config.opts.lang.typescript.coverage_file)
end

--- Returns a list of signs to be placed.
M.sign_list = python.sign_list

--- Returns a summary report.
M.summary = python.summary

return M
