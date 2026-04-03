local M = {}

function M.setup()
	vim.cmd.packadd("nvim.undotree")
	vim.keymap.set("n", "<leader>u", "<cmd>Undotree<CR>", { desc = "Open undo tree" })
end

return M
