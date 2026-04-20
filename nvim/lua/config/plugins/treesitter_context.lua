local M = {}

M.spec = {
	src = "https://github.com/nvim-treesitter/nvim-treesitter-context",
}

function M.setup()
	local ok, treesitter_context = pcall(require, "treesitter-context")
	if not ok then
		return
	end

	treesitter_context.setup({ separator = "~" })
end

return M
