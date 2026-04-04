local M = {}

M.spec = {
	src = "https://github.com/mfussenegger/nvim-dap-python",
}

function M.setup()
	local ok_dap, dap = pcall(require, "dap")
	local ok_dap_python, dap_python = pcall(require, "dap-python")
	if not ok_dap or not ok_dap_python then
		return
	end

	-- Keep dap-python helpers (test_method/test_class), but run adapter through uv.
	dap_python.setup("python3")
	dap.adapters.python = {
		type = "executable",
		command = "uv",
		args = { "run", "--with", "debugpy", "python", "-m", "debugpy.adapter" },
	}

	vim.keymap.set("n", "<leader>dn", dap_python.test_method, { desc = "Debug: Nearest test" })
	vim.keymap.set("n", "<leader>dN", dap_python.test_class, { desc = "Debug: Test class" })
end

return M
