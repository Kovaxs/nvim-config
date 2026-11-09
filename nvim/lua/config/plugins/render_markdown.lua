local M = {}

M.spec = {
	src = "https://github.com/meanderingprogrammer/render-markdown.nvim",
	version = vim.version.range("*"),
}

function M.setup()
	local ok, render_markdown = pcall(require, "render-markdown")
	if not ok then
		return
	end

	render_markdown.setup({
		-- Needs the markdown/markdown_inline treesitter parsers (see treesitter.lua).
		file_types = { "markdown" },
		completions = { lsp = { enabled = true } },
	})
end

return M
