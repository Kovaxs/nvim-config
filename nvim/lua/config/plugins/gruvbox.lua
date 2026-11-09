local M = {}

-- Italicize keyword groups, including every treesitter @keyword* group. Set to false to keep them upright.
local KEYWORD_ITALIC = true
local keyword_groups = { "Keyword", "Statement", "Conditional", "Repeat", "Include", "Exception" }

local function italicize_keywords()
	local names = vim.deepcopy(keyword_groups)
	for name in pairs(vim.api.nvim_get_hl(0, {})) do
		if name:find("^@keyword") then
			table.insert(names, name)
		end
	end
	for _, name in ipairs(names) do
		local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
		hl.italic = true
		vim.api.nvim_set_hl(0, name, hl)
	end
end

M.spec = {
	src = "https://github.com/ellisonleao/gruvbox.nvim",
}

function M.setup()
	local ok, gruvbox = pcall(require, "gruvbox")
	if not ok then
		return
	end

	gruvbox.setup({
		contrast = "",
		transparent_mode = true,
		italic = {
			strings = true,
			emphasis = true,
			comments = true,
			operators = false,
			folds = true,
		},
	})

	if KEYWORD_ITALIC then
		-- registered before colorscheme so it re-applies on every theme load
		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("GruvboxKeywordItalic", { clear = true }),
			callback = italicize_keywords,
		})
	end

	vim.opt.background = "dark"
	vim.cmd.colorscheme("gruvbox")
end

return M
