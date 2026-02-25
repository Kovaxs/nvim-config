return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false, -- Important: Load this early so parsers are available
		config = function()
			-- The new way to ensure parsers are installed
			local ensure_installed = {
				"query",
				"lua",
				"python",
				"latex",
				"bibtex",
				"json",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"vim",
				"gitignore",
				"vimdoc",
				"c",
				"nix",
				"regex",
				"cpp",
				"rust",
			}

			local ts = require("nvim-treesitter")
			local already_installed = ts.get_installed()
			local to_install = {}

			-- Check which languages from our list are missing
			for _, lang in ipairs(ensure_installed) do
				if not vim.tbl_contains(already_installed, lang) then
					table.insert(to_install, lang)
				end
			end

			-- Install missing languages
			if #to_install > 0 then
				ts.install(to_install)
			end

			-- NOTE: 'highlight', 'indent', and 'incremental_selection' are gone from the core plugin.
			-- Highlighting and indenting are now handled by Neovim's native core automatically.
		end,
	},
}
