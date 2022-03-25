local M = {}

local _, builtin = pcall(require, "telescope.builtin")

function M.setup()
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("project")
	require("telescope").load_extension("luasnip")
	require("telescope").load_extension("repo")

	local actions = require("telescope.actions")

	require("telescope").setup({
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
				},
			},
		},
	})

	M.search_dotfiles = function()
		builtin.find_files({
			prompt_title = "< VimRC >",
			cwd = "$HOME/dotfiles/",
		})
	end

	-- Smartly opens either git_files or find_files, depending on whether the working directory is
	-- contained in a Git repo.
	function M.find_project_files()
		local ok = pcall(builtin.git_files)

		if not ok then
			builtin.find_files()
		end
	end

	M.switch_projects = function()
		builtin.find_files({
			prompt_title = "< Switch Project >",
			cwd = "$HOME/",
		})
	end

	M.git_branches = function()
		require("telescope.builtin").git_branches({
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<c-d>", actions.git_delete_branch)
				map("n", "<c-d>", actions.git_delete_branch)
				return true
			end,
		})
	end
end

return M
