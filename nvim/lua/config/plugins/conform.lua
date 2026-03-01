return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				-- javascript = { "prettier" },
				-- typescript = { "prettier" },
				-- javascriptreact = { "prettier" },
				-- typescriptreact = { "prettier" },
				-- svelte = { "prettier" },
				-- css = { "prettier" },
				-- html = { "prettier" },
				-- json = { "prettier" },
				-- yaml = { "prettier" },
				-- markdown = { "prettier" },
				-- graphql = { "prettier" },
				-- liquid = { "prettier" },

				-- markdown = { "codespell" },
				sql = { "sql_formatter" },
				c = { "clang_format" },
				lua = { "stylua" },
				python = { "ruff_format" },
				rust = { "rustfmt", lsp_format = "fallback" },
				markdown = { "injected" },
				["_"] = { "trim_whitespace" },
			},
			format_on_save = {
				lsp_format = "fallback",
				async = false,
				timeout_ms = 1000,
			},
		})
	end,
}
