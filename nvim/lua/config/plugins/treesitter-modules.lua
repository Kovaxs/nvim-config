return {
	"MeanderingProgrammer/treesitter-modules.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		-- This restores your exact incremental selection setup!
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<CR>",
				node_incremental = "<CR>",
				scope_incremental = false,
				node_decremental = "<BS>",
			},
		},
	},
}
