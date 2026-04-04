local M = {}

M.spec = {
	src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
}

function M.setup()
	local ok, mason_tool_installer = pcall(require, "mason-tool-installer")
	if not ok then
		return
	end

	mason_tool_installer.setup({
		ensure_installed = {
			"clang-format",
			"cpplint",
			"eslint_d",
			"gofumpt",
			"goimports",
			"golangci-lint",
			"htmlhint",
			"jsonlint",
			"luacheck",
			"markdownlint-cli2",
			"prettierd",
			"ruff",
			"shellcheck",
			"shfmt",
			"stylelint",
			"stylua",
		},
		auto_update = false,
		run_on_start = true,
		start_delay = 3000,
	})
end

return M
