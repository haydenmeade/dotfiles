local M = {}

function M.setup()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end
  local builtin = require "telescope.builtin"
  local trouble = require "trouble.providers.telescope"
  local utils = require "telescope.utils"
  local actions = require "telescope.actions"

  telescope.load_extension "fzf"
  telescope.load_extension "luasnip"
  telescope.load_extension "repo"

  telescope.setup {
    find_command = {
      "rg",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
    use_less = true,
    extensions = {
      fzf = {
        override_generic_sorter = false,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-t>"] = trouble.open_with_trouble,
        },
        n = {
          ["<C-t>"] = trouble.open_with_trouble,
        },
      },
    },
  }

  M.search_dotfiles = function()
    builtin.find_files {
      prompt_title = "< VimRC >",
      cwd = "$HOME/dotfiles/",
    }
  end

  -- Smartly opens either git_files or find_files, depending on whether the working directory is
  -- contained in a Git repo.
  function M.find_project_files()
    local _, ret, _ = utils.get_os_command_output { "git", "rev-parse", "--is-inside-work-tree" }
    if ret == 0 then
      builtin.git_files()
    else
      builtin.find_files()
    end
  end

  M.git_branches = function()
    builtin.git_branches {
      attach_mappings = function(prompt_bufnr, map)
        map("i", "<c-d>", actions.git_delete_branch)
        map("n", "<c-d>", actions.git_delete_branch)
        return true
      end,
    }
  end
end

return M
