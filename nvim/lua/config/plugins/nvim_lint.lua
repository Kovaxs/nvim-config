local M = {}

M.spec = {
	src = "https://github.com/mfussenegger/nvim-lint",
}

function M.setup()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return
	end

	local codespell = lint.linters.codespell
	if codespell then
		codespell.args = { "--stdin-single-line", "-", "--quiet-level=2" }
	end

	lint.linters_by_ft = {
		bash = { "shellcheck", "codespell" },
		c = { "cpplint", "codespell" },
		cpp = { "cpplint", "codespell" },
		css = { "stylelint" },
		gitcommit = { "codespell" },
		go = { "golangcilint", "codespell" },
		html = { "htmlhint" },
		javascript = { "eslint_d", "codespell" },
		javascriptreact = { "eslint_d", "codespell" },
		json = { "jsonlint" },
		jsonc = { "jsonlint" },
		lua = { "luacheck", "codespell" },
		markdown = { "markdownlint-cli2", "codespell" },
		python = { "ruff", "codespell" },
		rust = { "codespell" },
		sh = { "shellcheck", "codespell" },
		text = { "codespell" },
		typescript = { "eslint_d", "codespell" },
		typescriptreact = { "eslint_d", "codespell" },
	}

	local group = vim.api.nvim_create_augroup("NvimLint", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
		group = group,
		callback = function()
			lint.try_lint()
		end,
	})
end

return M
