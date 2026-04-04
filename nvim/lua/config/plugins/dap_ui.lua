local M = {}

M.spec = {
	src = "https://github.com/rcarriga/nvim-dap-ui",
}

function M.setup()
	local ok_dap, dap = pcall(require, "dap")
	local ok_dapui, dapui = pcall(require, "dapui")
	if not ok_dap or not ok_dapui then
		return
	end

	dapui.setup()

	dap.listeners.before.attach.dapui_config = function()
		dapui.open()
	end

	dap.listeners.before.launch.dapui_config = function()
		dapui.open()
	end

	dap.listeners.before.event_terminated.dapui_config = function()
		dapui.close()
	end

	dap.listeners.before.event_exited.dapui_config = function()
		dapui.close()
	end
end

return M
