local M = {}

M.spec = {
	src = "https://github.com/folke/which-key.nvim",
}

function M.setup()
	local ok, which_key = pcall(require, "which-key")
	if not ok then
		return
	end

	which_key.setup()
	which_key.add({
		{ "<leader>d", group = "Debug" },
		{ "<leader>n", group = "Notify" },
		{ "<leader>h", group = "Harpoon" },
		{ "<leader>g", group = "Git" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>b", group = "Buffer" },
		{ "<leader>c", group = "Lang" },
		{ "<leader>e", group = "Nvim config pickers" },
		{ "<leader>f", group = "fzf pickers" },
		{ "<leader>o", group = "Terminal" },
		{ "<leader>t", group = "Diagnostic" },
		{ "<leader><leader>", group = "Lua source" },
		{ "<leader>y", group = "Yank path" },
	})
end

return M
