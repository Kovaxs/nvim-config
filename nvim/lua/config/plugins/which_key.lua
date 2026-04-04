local M = {}

M.spec = {
	src = "https://github.com/folke/which-key.nvim",
}

function M.setup()
	local ok, which_key = pcall(require, "which-key")
	if not ok then
		return
	end

	which_key.setup()
end

return M
