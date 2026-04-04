local M = {}

-- Parsers we want available for highlighting, folds, and textobjects.
local ensure_installed = {
	"vim",
	"vimdoc",
	"rust",
	"c",
	"cpp",
	"go",
	"html",
	"css",
	"javascript",
	"json",
	"lua",
	"markdown",
	"python",
	"typescript",
	"vue",
	"svelte",
	"bash",
}

M.spec = {
	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	version = "main",
}

local function update_parsers()
	-- Prefer the plugin's synchronous update command when available.
	if vim.fn.exists(":TSUpdateSync") == 2 then
		vim.cmd("TSUpdateSync " .. table.concat(ensure_installed, " "))
		return
	end

	-- Fallback: request installation via Lua API.
	local ok, treesitter = pcall(require, "nvim-treesitter")
	if ok then
		treesitter.install(ensure_installed)
	end
end

function M.pre_setup()
	-- Register pack hooks before `vim.pack.add()` runs.
	local group = vim.api.nvim_create_augroup("TreeSitterPackHooks", { clear = true })

	vim.api.nvim_create_autocmd("PackChanged", {
		group = group,
		callback = function(ev)
			-- Guard against unexpected event payloads.
			local data = ev.data
			if not data or not data.spec then
				return
			end

			-- React only to nvim-treesitter changes.
			if data.spec.name ~= "nvim-treesitter" then
				return
			end

			-- Run only on install/update, not delete.
			if data.kind ~= "install" and data.kind ~= "update" then
				return
			end

			-- Ensure plugin commands/Lua are available in this session.
			if not data.active then
				vim.cmd.packadd("nvim-treesitter")
			end

			-- Refresh maintained parsers after code changes.
			update_parsers()
		end,
	})
end

function M.setup()
	-- Load plugin API safely to avoid startup hard-failures.
	local ok, treesitter = pcall(require, "nvim-treesitter")
	if not ok then
		return
	end

	-- Apply base treesitter defaults.
	treesitter.setup({})

	-- Read parser state through plugin config helper.
	local ok_config, config = pcall(require, "nvim-treesitter.config")
	if not ok_config then
		return
	end

	-- Compute the missing parser set from desired list.
	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	-- Install only missing parsers; prefer synchronous CLI command.
	if #parsers_to_install > 0 then
		if vim.fn.exists(":TSInstallSync") == 2 then
			vim.cmd("TSInstallSync " .. table.concat(parsers_to_install, " "))
		else
			treesitter.install(parsers_to_install)
		end
	end

	-- Start treesitter automatically for buffers with available parsers.
	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			-- Resolve filetype to parser language name safely.
			local ok_lang, language = pcall(vim.treesitter.language.get_lang, args.match)
			if ok_lang and vim.tbl_contains(treesitter.get_installed(), language) then
				-- Attach parser to current buffer.
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

return M
