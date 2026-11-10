local M = {}

M.spec = {
	src = "https://github.com/folke/zen-mode.nvim",
}

function M.setup()
	local ok, zen_mode = pcall(require, "zen-mode")
	if not ok then
		return
	end

	zen_mode.setup()

	vim.keymap.set("n", "<leader>z", function()
		zen_mode.toggle()
	end, { desc = "Toggle zen mode" })
end

return M
