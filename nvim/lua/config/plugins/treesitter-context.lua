return {
	"nvim-treesitter/nvim-treesitter-context",
	event = "VeryLazy",
	config = function()
		require("treesitter-context").setup({
			enable = true,
			multiwindow = false,
			max_lines = 0,
			min_window_height = 0,
			line_numbers = true,
			multiline_threshold = 2,
			trim_scope = "outer",
			mode = "cursor",
			separator = "-",
			zindex = 20,
			on_attach = nil,
		})
	end,
}
