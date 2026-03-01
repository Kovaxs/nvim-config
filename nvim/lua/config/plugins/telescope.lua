return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			pickers = {
				find_files = {
					theme = "ivy",
				},
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")
			telescope.setup(opts)

			pcall(telescope.load_extension, "git_worktree")
			pcall(telescope.load_extension, "refactoring")
			pcall(telescope.load_extension, "dap")
			pcall(telescope.load_extension, "harpoon")
		end,
	},
}
