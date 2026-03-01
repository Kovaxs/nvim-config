return {
	'ThePrimeagen/git-worktree.nvim',
	dependencies = { 'nvim-telescope/telescope.nvim' },
	keys = {
		{
			"<leader>gr",
			function()
				require("telescope").extensions.git_worktree.git_worktrees()
			end,
			desc = "Show worktrees in Telescope",
		},
		{
			"<leader>gR",
			function()
				require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			desc = "Create worktrees in Telescope",
		},
	},
	config = function()
		require("git-worktree").setup()
		require("telescope").load_extension("git_worktree")
    end
}
