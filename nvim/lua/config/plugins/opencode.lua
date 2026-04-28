local M = {}

M.spec = {
	src = "https://github.com/nickjvandyke/opencode.nvim",
}

function M.setup()
	local ok, opencode = pcall(require, "opencode")
	if not ok then
		return
	end

	vim.g.opencode_opts = vim.g.opencode_opts or {}
	vim.o.autoread = true

	vim.keymap.set({ "n", "x" }, "<leader>oa", function()
		opencode.ask("@this: ", { submit = true })
	end, { desc = "Opencode: Ask" })

	vim.keymap.set({ "n", "x" }, "<leader>os", function()
		opencode.select()
	end, { desc = "Opencode: Select action" })

	vim.keymap.set({ "n" }, "<leader>oo", function()
		opencode.toggle()
	end, { desc = "Opencode: Toggle" })
end

return M
