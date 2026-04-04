local M = {}

M.spec = {
	src = "https://github.com/mfussenegger/nvim-lint",
}

function M.setup()
	local ok, lint = pcall(require, "lint")
	if not ok then
		return
	end

	lint.linters_by_ft = {
		c = { "cpplint" },
		cpp = { "cpplint" },
		css = { "stylelint" },
		go = { "golangcilint" },
		html = { "htmlhint" },
		javascript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		json = { "jsonlint" },
		jsonc = { "jsonlint" },
		lua = { "luacheck" },
		markdown = { "markdownlint-cli2" },
		python = { "ruff" },
		sh = { "shellcheck" },
		typescript = { "eslint_d" },
		typescriptreact = { "eslint_d" },
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
