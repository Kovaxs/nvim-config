local M = {}

local plugins = {
	-- require("config.plugins.gitsigns"),
	-- require("config.plugins.mini"),
	require("config.plugins.fzf_lua"),
	-- require("config.plugins.nvim_tree"),
	require("config.plugins.nvim_undotree"),
	require("config.plugins.nvim_difftool"),
	-- require("config.plugins.treesitter"),
	-- require("config.plugins.lspconfig"),
	-- require("config.plugins.mason"),
	-- require("config.plugins.efmls"),
	-- require("config.plugins.blink"),
	-- require("config.plugins.luasnip"),
}

local function collect_specs()
	local specs = {}
	for _, plugin in ipairs(plugins) do
		if plugin.spec then
			table.insert(specs, plugin.spec)
		end
	end
	return specs
end

local function setup_plugins()
	for _, plugin in ipairs(plugins) do
		if type(plugin.setup) == "function" then
			plugin.setup()
		end
	end
end

function M.setup()
	vim.pack.add(collect_specs(), {
		load = true,
		confirm = false,
	})

	setup_plugins()
end

return M
