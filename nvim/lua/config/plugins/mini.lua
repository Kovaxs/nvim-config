local M = {}

M.spec = {
	src = "https://github.com/echasnovski/mini.nvim",
}

function M.setup()
	local modules = {
		"surround",
		"cursorword",
		"indentscope",
		"pairs",
		"notify",
		"icons",
	}

	local opts = {
		indentscope = {
			draw = {
				delay = 100,
				animation = require("mini.indentscope").gen_animation.none(),
			},
		},
	}

	for _, module in ipairs(modules) do
		local ok, mini_module = pcall(require, "mini." .. module)
		if ok then
			mini_module.setup(opts[module] or {})
		end
	end

	-- keymaps
	vim.keymap.set("n", "<leader>nh", function()
		local ok, mini_notify = pcall(require, "mini.notify")
		if not ok then
			vim.notify("mini.notify is not available", vim.log.levels.WARN)
			return
		end

		mini_notify.show_history()
	end, { desc = "Notify: Show history" })
end

return M
