local M = {}

function M.setup()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end
  local builtin = require "telescope.builtin"
  local utils = require "telescope.utils"
  local actions = require "telescope.actions"
  local previewers = require "telescope.previewers"

  telescope.load_extension "session-lens"
  telescope.load_extension "fzf"
  telescope.load_extension "luasnip"
  telescope.load_extension "repo"
  telescope.load_extension "file_browser"

  local largeFilesIgnoringPreviewer = function(filepath, bufnr, opts)
    opts = opts or {}

    filepath = vim.fn.expand(filepath)
    vim.loop.fs_stat(filepath, function(_, stat)
      if not stat then
        return
      end
      if stat.size > 100000 then
        return
      else
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      end
    end)
  end

  local function openqf(arg)
    actions.send_to_qflist(arg)
    require("trouble").open "quickfix"
  end

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
      buffer_previewer_maker = largeFilesIgnoringPreviewer,
      mappings = {
        i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
          ["<C-t>"] = openqf,
        },
        n = {
          ["<C-t>"] = openqf,
        },
      },
    },
  }

  M.search_dotfiles = function()
    builtin.find_files {
      prompt_title = "< Nvim Config >",
      cwd = "$HOME/dotfiles/",
    }
  end
  M.search_gopath = function()
    builtin.find_files {
      prompt_title = "< Go project >",
      cwd = "$HOME/go/src",
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

  local live_grep_in_glob = function(glob_pattern)
    require("telescope.builtin").live_grep {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--glob=" .. (glob_pattern or ""),
      },
    }
  end

  M.live_grep_in_glob = function()
    vim.ui.input({ prompt = "Glob: ", completion = "file", default = "**/*." }, live_grep_in_glob)
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
