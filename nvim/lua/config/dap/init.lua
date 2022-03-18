local M = {}

function M.nvim_dap_setup()
	-- DAPInstall
	local dap_install = require("dap-install")
	dap_install.setup({
		installation_path = vim.fn.stdpath("data") .. "/dapinstall/",
	})

	-- telescope-dap
	require("telescope").load_extension("dap")

	-- nvim-dap-ui
	require("dapui").setup({})

	-- languages
	-- require("config.dap.python").setup()
	require("config.dap.go").setup()

	-- nvim-dap
	vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })
	vim.fn.sign_define("DapStopped", { text = "⭐️", texthl = "", linehl = "", numhl = "" })
end

function M.setup()
	M.nvim_dap_setup()

	-- key mappings
	local wk = require("config.whichkey")
	wk.register_dap()
end

return M
