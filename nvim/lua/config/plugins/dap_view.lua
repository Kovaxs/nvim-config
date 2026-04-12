local M = {}

M.spec = {
	src = "https://github.com/igorlfs/nvim-dap-view",
}

function M.setup()
	local ok_dap, dap = pcall(require, "dap")
	local ok_view, dap_view = pcall(require, "dap-view")
	if not ok_dap or not ok_view then
		return
	end

	dap_view.setup({
		windows = {
			terminal = {
				position = "right",
			},
		},
		winbar = { default_section = "repl" },
	})

	dap.listeners.before.attach.dapview_config = function()
		vim.cmd("DapViewOpen")
	end

	dap.listeners.before.launch.dapview_config = function()
		vim.cmd("DapViewOpen")
	end

	dap.listeners.before.event_terminated.dapview_config = function()
		vim.cmd("DapViewClose")
	end

	dap.listeners.before.event_exited.dapview_config = function()
		vim.cmd("DapViewClose")
	end
end

return M
