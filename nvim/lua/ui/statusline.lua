-- =====================================================================================
-- gruvbox-style status line
-- =====================================================================================

local M = {}

local branch_cache = {}
local branch_cache_ttl = 5000

local filetype_icons = {
	lua = "\u{e620} ",
	python = "\u{e73c} ",
	javascript = "\u{e74e} ",
	typescript = "\u{e628} ",
	javascriptreact = "\u{e7ba} ",
	typescriptreact = "\u{e7ba} ",
	html = "\u{e736} ",
	css = "\u{e749} ",
	scss = "\u{e749} ",
	json = "\u{e60b} ",
	markdown = "\u{e73e} ",
	vim = "\u{e62b} ",
	sh = "\u{f489} ",
	bash = "\u{f489} ",
	zsh = "\u{f489} ",
	rust = "\u{e7a8} ",
	go = "\u{e724} ",
	c = "\u{e61e} ",
	cpp = "\u{e61d} ",
	java = "\u{e738} ",
	php = "\u{e73d} ",
	ruby = "\u{e739} ",
	swift = "\u{e755} ",
	kotlin = "\u{e634} ",
	dart = "\u{e798} ",
	elixir = "\u{e62d} ",
	haskell = "\u{e777} ",
	sql = "\u{e706} ",
	yaml = "\u{f481} ",
	toml = "\u{e615} ",
	xml = "\u{f05c} ",
	dockerfile = "\u{f308} ",
	gitcommit = "\u{f418} ",
	gitconfig = "\u{f1d3} ",
	vue = "\u{fd42} ",
	svelte = "\u{e697} ",
	astro = "\u{e628} ",
}

local mode_icons = {
	n = " \u{f121} NORMAL ",
	i = " \u{f11c} INSERT ",
	v = " \u{f0168} VISUAL ",
	V = " \u{f0168} V-LINE ",
	["\22"] = " \u{f0168} V-BLOCK ",
	c = " \u{f120} COMMAND ",
	s = " \u{f0c5} SELECT ",
	S = " \u{f0c5} S-LINE ",
	["\19"] = " \u{f0c5} S-BLOCK ",
	R = " \u{f044} REPLACE ",
	r = " \u{f044} REPLACE ",
	["!"] = " \u{f489} SHELL ",
	t = " \u{f120} TERMINAL ",
}

local function lsp_server()
	-- vim.lsp.get_clients is the modern API for Neovim 0.10+
	-- We add a fallback to get_active_clients for older versions just in case
	local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
	local clients = get_clients({ bufnr = 0 })

	if next(clients) == nil then
		return "" -- Return nothing if no LSP is attached
	end

	local client_names = {}
	for _, client in ipairs(clients) do
		table.insert(client_names, client.name)
	end

	-- \u{f085} is the cog/gear icon (nf-fa-cogs)
	return " \u{f085} " .. table.concat(client_names, ", ") .. " "
end

local function diagnostics()
	local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
	local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
	local info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })

	local parts = {}

	if errors > 0 then
		table.insert(parts, "%#SlDiagError#  " .. errors)
	end
	if warnings > 0 then
		table.insert(parts, "%#SlDiagWarn#  " .. warnings)
	end
	if info > 0 then
		table.insert(parts, "%#SlDiagInfo#  " .. info)
	end
	if hints > 0 then
		table.insert(parts, "%#SlDiagHint#  " .. hints)
	end

	if #parts > 0 then
		return table.concat(parts) .. " "
	end

	return ""
end

local function get_git_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
		return nil
	end

	-- Remove the "oil://" prefix so Git can read the path correctly
	bufname = bufname:gsub("^oil://", "")

	-- It is also a good idea to ignore terminal buffers
	if bufname:match("^term://") then
		return nil
	end

	local dir = vim.fs.dirname(bufname)
	if not dir then
		return nil
	end

	local git_dir = vim.fn.finddir(".git", dir .. ";")
	if git_dir == "" then
		git_dir = vim.fn.findfile(".git", dir .. ";")
	end
	if git_dir == "" then
		return nil
	end

	return vim.fn.fnamemodify(git_dir, ":p:h")
end

local function git_branch()
	local root = get_git_root()
	if not root then
		return ""
	end

	local now = vim.uv.now()
	local cached = branch_cache[root]
	if not cached or now - cached.last_check > branch_cache_ttl then
		local output = vim.fn.systemlist({ "git", "-C", root, "branch", "--show-current" })
		cached = {
			branch = vim.trim(output[1] or ""),
			last_check = now,
		}
		branch_cache[root] = cached
	end

	if cached.branch ~= "" then
		return " \u{e725} " .. cached.branch .. " "
	end

	return ""
end

local function file_type()
	local ft = vim.bo.filetype
	if ft == "" then
		return " \u{f15b} "
	end

	return " " .. (filetype_icons[ft] or "\u{f15b} ") .. ft .. " "
end

local function file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size < 0 then
		return ""
	end

	local size_str
	if size < 1024 then
		size_str = size .. "B"
	elseif size < 1024 * 1024 then
		size_str = string.format("%.1fK", size / 1024)
	else
		size_str = string.format("%.1fM", size / 1024 / 1024)
	end

	return " \u{f016} " .. size_str .. " "
end

local function mode_icon()
	local mode = vim.fn.mode()
	return mode_icons[mode] or (" " .. mode .. " ")
end

function M.render_active()
	return table.concat({
		-- MODE
		"%#SlMode#",
		mode_icon(),
		"%#SlSepModeGit#\u{e0b0}",

		-- GIT
		"%#SlGit#",
		git_branch(),
		"%#SlSepGitFile#\u{e0b0}",

		-- DIAGNOSTICS & FILE
		diagnostics(),
		"%#SlFile#",
		" %f %h%m%r ",
		"%#SlSepFileBase#\u{e0b0}",

		-- CENTERED LSP SERVER
		"%#SlBase#",
		"%=", -- Push from the left
		lsp_server(), -- Centered text
		"%=", -- Push from the right

		-- FILE SIZE & FILETYPE
		"%#SlSepBaseFile#\u{e0b2}",
		"%#SlFile#",
		file_size(),
		"|",
		file_type(),

		-- POSITION (Top/Bot)
		"%#SlSepFileGit#\u{e0b2}",
		"%#SlGit#",
		"  %P  ",

		-- LINE:COL
		"%#SlSepGitMode#\u{e0b2}",
		"%#SlMode#",
		"  %l:%c  ",
	})
end

function M.render_inactive()
	return table.concat({
		"%#SlFile#",
		"  %f %h%m%r ",
		" %= ",
		file_type(),
		"  %l:%c   %P ",
	})
end

function M.setup()
	if M._did_setup then
		return
	end
	M._did_setup = true

	-- Gruvbox Colors
	-- local c_mode_bg = "#a89984"
	-- local c_mode_fg = "#282828"
	-- local c_git_bg = "#504945"
	-- local c_git_fg = "#ddc7a1"
	-- local c_file_bg = "#3c3836"
	-- local c_file_fg = "#a89984"
	-- local c_base_bg = "#282828"
	-- Vibrant Gruvbox Colors
	local c_mode_bg = "#d79921" -- Gruvbox Yellow
	local c_mode_fg = "#282828" -- Dark text
	local c_git_bg = "#458588" -- Gruvbox Blue
	local c_git_fg = "#ebdbb2" -- Light beige text
	local c_file_bg = "#504945" -- Medium Gray
	local c_file_fg = "#ebdbb2" -- Light beige text
	local c_base_bg = "#282828" -- Base background (middle area)

	-- New Diagnostic Colors
	local c_diag_err = "#cc241d" -- Gruvbox Red
	local c_diag_warn = "#d79921" -- Gruvbox Yellow
	local c_diag_info = "#458588" -- Gruvbox Blue
	local c_diag_hint = "#689d6a" -- Gruvbox Aqua

	-- Diagnostic Highlights (Foreground is the colored icon, Background matches the File block)
	vim.api.nvim_set_hl(0, "SlDiagError", { bg = c_file_bg, fg = c_diag_err, bold = true })
	vim.api.nvim_set_hl(0, "SlDiagWarn", { bg = c_file_bg, fg = c_diag_warn, bold = true })
	vim.api.nvim_set_hl(0, "SlDiagInfo", { bg = c_file_bg, fg = c_diag_info, bold = true })
	vim.api.nvim_set_hl(0, "SlDiagHint", { bg = c_file_bg, fg = c_diag_hint, bold = true })

	-- Block Highlights
	vim.api.nvim_set_hl(0, "SlMode", { bg = c_mode_bg, fg = c_mode_fg, bold = true })
	vim.api.nvim_set_hl(0, "SlGit", { bg = c_git_bg, fg = c_git_fg })
	vim.api.nvim_set_hl(0, "SlFile", { bg = c_file_bg, fg = c_file_fg })
	vim.api.nvim_set_hl(0, "SlBase", { bg = c_base_bg })

	-- Left Separators (Foreground is current block, Background is next block)
	vim.api.nvim_set_hl(0, "SlSepModeGit", { fg = c_mode_bg, bg = c_git_bg })
	vim.api.nvim_set_hl(0, "SlSepGitFile", { fg = c_git_bg, bg = c_file_bg })
	vim.api.nvim_set_hl(0, "SlSepFileBase", { fg = c_file_bg, bg = c_base_bg })

	-- Right Separators (Foreground is next block, Background is current block)
	vim.api.nvim_set_hl(0, "SlSepBaseFile", { fg = c_file_bg, bg = c_base_bg })
	vim.api.nvim_set_hl(0, "SlSepFileGit", { fg = c_git_bg, bg = c_file_bg })
	vim.api.nvim_set_hl(0, "SlSepGitMode", { fg = c_mode_bg, bg = c_git_bg })

	local augroup = vim.api.nvim_create_augroup("CustomStatusline", { clear = true })
	vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
		group = augroup,
		callback = function()
			vim.opt_local.statusline = "%!v:lua.require'ui.statusline'.render_active()"
		end,
	})

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		group = augroup,
		callback = function()
			vim.opt_local.statusline = "%!v:lua.require'ui.statusline'.render_inactive()"
		end,
	})

	vim.opt.statusline = "%!v:lua.require'ui.statusline'.render_active()"
end

return M
