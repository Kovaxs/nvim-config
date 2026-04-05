local M = {}

M.spec = {
	src = "https://github.com/mason-org/mason-lspconfig.nvim",
}

function M.setup()
	local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	if not ok then
		return
	end

	local ensure_installed = {
		"lua_ls", -- Lua
		"ty", -- Python
		"ruff", -- Python (code actions / lint)
		"bashls", -- Bash / shell
		"ts_ls", -- TypeScript / JavaScript
		"gopls", -- Go
		"clangd", -- C / C++
		"rust_analyzer", -- Rust
		"nil_ls", -- Nix
		"zls", -- Zig
	}

	mason_lspconfig.setup({
		ensure_installed = ensure_installed,
		automatic_enable = false,
	})
end

return M
