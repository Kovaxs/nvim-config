local M = {}

M.spec = {
	src = "https://github.com/L3MON4D3/LuaSnip",
	version = "v2.5.0",
}

function M.pre_setup()
	local group = vim.api.nvim_create_augroup("LuaSnipPackHooks", { clear = true })

	vim.api.nvim_create_autocmd("PackChanged", {
		group = group,
		callback = function(ev)
			local data = ev.data
			if not data or not data.spec then
				return
			end

			if data.spec.name ~= "LuaSnip" then
				return
			end

			if data.kind ~= "install" and data.kind ~= "update" then
				return
			end

			if vim.fn.executable("make") == 1 then
				vim.system({ "make", "install_jsregexp" }, { cwd = data.path }):wait()
			end
		end,
	})
end

function M.setup()
	local ok, luasnip = pcall(require, "luasnip")
	if not ok then
		return
	end

	luasnip.config.set_config({
		history = true,
		updateevents = "TextChanged,TextChangedI",
	})

	local ok_loader, lua_loader = pcall(require, "luasnip.loaders.from_lua")
	if ok_loader then
		lua_loader.load({ paths = { vim.fn.stdpath("config") .. "/LuaSnip" } })
	end
end

return M
