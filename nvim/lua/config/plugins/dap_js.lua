local M = {}

local js_filetypes = {
	"javascript",
	"javascriptreact",
	"typescript",
	"typescriptreact",
}

local function js_debug_adapter_command()
	local adapter = vim.fn.exepath("js-debug-adapter")
	return adapter ~= "" and adapter or "js-debug-adapter"
end

local function pick_node_process()
	local ok, utils = pcall(require, "dap.utils")
	if ok then
		return utils.pick_process()
	end

	return vim.fn.input("Process ID: ")
end

local function chrome_url()
	return vim.fn.input("URL: ", "http://localhost:3000")
end

function M.setup()
	local ok, dap = pcall(require, "dap")
	if not ok then
		return
	end

	for _, adapter in ipairs({ "pwa-node", "pwa-chrome" }) do
		dap.adapters[adapter] = {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = js_debug_adapter_command(),
				args = { "${port}" },
			},
		}
	end

	local configs = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file (Node)",
			program = "${file}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file (tsx)",
			runtimeExecutable = "tsx",
			program = "${file}",
			cwd = "${workspaceFolder}",
			console = "integratedTerminal",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach to Node process",
			processId = pick_node_process,
			cwd = "${workspaceFolder}",
			sourceMaps = true,
			skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
		},
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Launch Chrome",
			url = chrome_url,
			webRoot = "${workspaceFolder}",
			sourceMaps = true,
			userDataDir = false,
		},
	}

	for _, filetype in ipairs(js_filetypes) do
		dap.configurations[filetype] = dap.configurations[filetype] or {}
		vim.list_extend(dap.configurations[filetype], vim.deepcopy(configs))
	end
end

return M
