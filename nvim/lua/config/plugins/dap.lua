local M = {}

M.spec = {
	src = "https://github.com/mfussenegger/nvim-dap",
}

function M.setup()
	local ok, dap = pcall(require, "dap")
	if not ok then
		return
	end

	vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
	vim.fn.sign_define(
		"DapBreakpointCondition",
		{ text = "◆", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" }
	)
	vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticSignInfo", linehl = "", numhl = "" })

	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue" })
	vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Debug: Run last" })

	vim.keymap.set("n", "<leader>dj", dap.step_over, { desc = "Debug: Step over" })
	vim.keymap.set("n", "<leader>dk", dap.step_into, { desc = "Debug: Step into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug: Step out" })

	vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle breakpoint" })
	vim.keymap.set("n", "<leader>dB", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, { desc = "Debug: Conditional breakpoint" })

	vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug: Toggle REPL" })
	vim.keymap.set("n", "<leader>dh", function()
		dap.repl.open()
		dap.repl.execute(".help")
	end, { desc = "Debug: REPL help" })

	vim.keymap.set("n", "<leader>dF", "<cmd>FzfLua dap_breakpoints<CR>", { desc = "Dabug: fzf breakpoints" })

	vim.keymap.set("n", "<leader>df", function()
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.frames)
	end, { desc = "Debug: Frames" })

	vim.keymap.set("n", "<leader>ds", function()
		local widgets = require("dap.ui.widgets")
		widgets.centered_float(widgets.scopes)
	end, { desc = "Debug: Scopes" })

	vim.keymap.set("n", "<leader>dv", function()
		require("dap.ui.widgets").hover()
	end, { desc = "Debug: Hover value" })

	vim.keymap.set("n", "<leader>du", function()
		require("dapui").toggle()
	end, { desc = "Debug: Toggle UI" })

	vim.keymap.set("n", "<leader>dU", function()
		require("dapui").open({ reset = true })
	end, { desc = "Debug: Reset UI" })

	vim.keymap.set("n", "<leader>dq", function()
		dap.disconnect()
		require("dapui").close()
	end, { desc = "Debug: Disconnect" })

	vim.keymap.set("n", "<leader>dx", function()
		dap.terminate()
		require("dapui").close()
	end, { desc = "Debug: Terminate" })
end

return M
