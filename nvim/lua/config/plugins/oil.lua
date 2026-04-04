local M = {}

M.spec = {
	src = "https://github.com/stevearc/oil.nvim",
}

function M.setup()
	local ok, oil = pcall(require, "oil")
	if not ok then
		return
	end

	oil.setup({
		view_options = {
			show_hidden = true,
		},
	})

	vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open Oil" })
end

return M
