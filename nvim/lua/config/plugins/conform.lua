local M = {}

M.spec = {
	src = "https://github.com/stevearc/conform.nvim",
}

function M.setup()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return
	end

	conform.setup({
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			css = { "prettierd" },
			go = { "gofumpt", "goimports" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			python = { "ruff_format" },
			sh = { "shfmt" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
		},
		format_on_save = {
			timeout_ms = 2000,
			lsp_format = "fallback",
		},
	})
end

return M
