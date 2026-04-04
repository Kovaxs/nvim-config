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
		c = { "cpplint", "typos" },
		cpp = { "cpplint", "typos" },
		css = { "stylelint" },
		gitcommit = { "typos" },
		go = { "golangcilint", "typos" },
		html = { "htmlhint" },
		javascript = { "eslint_d", "typos" },
		javascriptreact = { "eslint_d", "typos" },
		json = { "jsonlint" },
		jsonc = { "jsonlint" },
		lua = { "luacheck", "typos" },
		markdown = { "markdownlint-cli2", "typos" },
		python = { "ruff", "typos" },
		rust = { "typos" },
		sh = { "shellcheck", "typos" },
		text = { "typos" },
		typescript = { "eslint_d", "typos" },
		typescriptreact = { "eslint_d", "typos" },
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
