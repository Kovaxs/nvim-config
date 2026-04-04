local M = {}

M.spec = {
	src = "https://github.com/mason-org/mason.nvim",
}

function M.setup()
	local ok, mason = pcall(require, "mason")
	if not ok then
		return
	end

	mason.setup({
		ui = {
			border = "rounded",
		},
	})
end

return M
