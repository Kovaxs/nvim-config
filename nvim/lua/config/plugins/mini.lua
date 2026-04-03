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
end

return M
