return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")
			configs.setup({
				ensure_installed = {
					"query",
					"lua",
					"python",
					"latex",
					"markdown",
					"markdown_inline",
					"bibtex",
					"json",
					"yaml",
					"html",
					"css",
					"markdown",
					"markdown_inline",
					"bash",
					"lua",
					"vim",
					"gitignore",
					"vimdoc",
					"c",
					"nix",
					"regex",
					"cpp",
					"rust",
				},
				auto_install = false,
				-- ignore_install = { "dockerfile", "Dockerfile" },
				modules = {},
				sync_install = false,
				highlight = { enable = true, disable = { "dockerfile", "Dockerfile" } },
				indent = { enable = true },
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>", -- set to `false` to disable one of the mappings
						node_incremental = "<CR>",
						scope_incremental = false,
						node_decremental = "<BS>",
					},
				},
			})
		end,
	},
}
