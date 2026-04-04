local M = {}

local plugins = {
	require("config.plugins.gitsigns"),
	require("config.plugins.mini"),
	require("config.plugins.fzf_lua"),
	require("config.plugins.nvim_undotree"),
	require("config.plugins.nvim_difftool"),
	require("config.plugins.treesitter"),
	require("config.plugins.mason"),
	require("config.plugins.mason_lspconfig"),
	require("config.plugins.mason_tools"),
	require("config.plugins.lspconfig"),
	require("config.plugins.conform"),
	require("config.plugins.nvim_lint"),
	require("config.plugins.friendly_snippets"),
	require("config.plugins.blink_cmp"),
	require("config.plugins.luasnip_plugin"),
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

local function pre_setup_plugins()
	for _, plugin in ipairs(plugins) do
		if type(plugin.pre_setup) == "function" then
			plugin.pre_setup()
		end
	end
end

local function setup_plugins()
	for _, plugin in ipairs(plugins) do
		if type(plugin.setup) == "function" then
			plugin.setup()
		end
	end
end

function M.setup()
	pre_setup_plugins()

	vim.pack.add(collect_specs(), {
		load = true,
		confirm = false,
	})

	setup_plugins()
end

return M
