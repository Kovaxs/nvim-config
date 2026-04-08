local M = {}

M.spec = {
	src = "https://github.com/rafamadriz/friendly-snippets",
}

function M.setup()
	local ok, loader = pcall(require, "luasnip.loaders.from_vscode")
	if not ok then return end
	loader.lazy_load()
end

return M
