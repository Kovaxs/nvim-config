local M = {}

-- Plugin source spec consumed by config/pack.lua
M.spec = {
	src = "https://github.com/ibhagwan/fzf-lua",
}

-- Runs after vim.pack loads the plugin
function M.setup()
	-- Safe require so startup does not fail if plugin is unavailable
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		return
	end

	-- Base preset + local overrides for UI and picker behavior
	fzf.setup({
		"fzf-native",
		-- Floating window layout
		winopts = {
			height = 0.85,
			width = 0.80,
			row = 0.35,
			col = 0.50,
			border = "rounded",
		},
		-- File picker defaults
		files = {
			hidden = true,
			no_ignore = false,
			git_icons = true,
		},
		-- ripgrep options used by live_grep and grep-like pickers
		grep = {
			rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git' -e",
		},
	})

	-- Search keymaps
	vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "Find files" })
	vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
	vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", { desc = "Find buffers" })
	vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua helptags<CR>", { desc = "Help tags" })
	vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", { desc = "Help keymaps" })
	vim.keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<CR>", { desc = "Recent files" })
	vim.keymap.set("n", "<leader>ft", "<cmd>FzfLua command_history<CR>", { desc = "Command history" })
end

return M
