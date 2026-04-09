local M = {}

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

	vim.opt.background = "dark"
	vim.cmd.colorscheme("gruvbox")
end

return M
