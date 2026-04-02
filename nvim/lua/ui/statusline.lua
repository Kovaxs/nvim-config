local M = {}

local branch_cache = {}
local branch_cache_ttl = 5000

local filetype_icons = {
	lua = "\u{e620} ", -- nf-dev-lua
	python = "\u{e73c} ", -- nf-dev-python
	javascript = "\u{e74e} ", -- nf-dev-javascript
	typescript = "\u{e628} ", -- nf-dev-typescript
	javascriptreact = "\u{e7ba} ",
	typescriptreact = "\u{e7ba} ",
	html = "\u{e736} ", -- nf-dev-html5
	css = "\u{e749} ", -- nf-dev-css3
	scss = "\u{e749} ",
	json = "\u{e60b} ", -- nf-dev-json
	markdown = "\u{e73e} ", -- nf-dev-markdown
	vim = "\u{e62b} ", -- nf-dev-vim
	sh = "\u{f489} ", -- nf-oct-terminal
	bash = "\u{f489} ",
	zsh = "\u{f489} ",
	rust = "\u{e7a8} ", -- nf-dev-rust
	go = "\u{e724} ", -- nf-dev-go
	c = "\u{e61e} ", -- nf-dev-c
	cpp = "\u{e61d} ", -- nf-dev-cplusplus
	java = "\u{e738} ", -- nf-dev-java
	php = "\u{e73d} ", -- nf-dev-php
	ruby = "\u{e739} ", -- nf-dev-ruby
	swift = "\u{e755} ", -- nf-dev-swift
	kotlin = "\u{e634} ",
	dart = "\u{e798} ",
	elixir = "\u{e62d} ",
	haskell = "\u{e777} ",
	sql = "\u{e706} ",
	yaml = "\u{f481} ",
	toml = "\u{e615} ",
	xml = "\u{f05c} ",
	dockerfile = "\u{f308} ", -- nf-linux-docker
	gitcommit = "\u{f418} ", -- nf-oct-git_commit
	gitconfig = "\u{f1d3} ", -- nf-fa-git
	vue = "\u{fd42} ", -- nf-md-vuejs
	svelte = "\u{e697} ",
	astro = "\u{e628} ",
}

local mode_icons = {
	n = " \u{f121}  NORMAL",
	i = " \u{f11c}  INSERT",
	v = " \u{f0168} VISUAL",
	V = " \u{f0168} V-LINE",
	["\22"] = " \u{f0168} V-BLOCK",
	c = " \u{f120} COMMAND",
	s = " \u{f0c5} SELECT",
	S = " \u{f0c5} S-LINE",
	["\19"] = " \u{f0c5} S-BLOCK",
	R = " \u{f044} REPLACE",
	r = " \u{f044} REPLACE",
	["!"] = " \u{f489} SHELL",
	t = " \u{f120} TERMINAL",
}

local function get_git_root()
	local bufname = vim.api.nvim_buf_get_name(0)
	if bufname == "" then
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
		return " \u{e725} " .. cached.branch .. " " -- nf-dev-git_branch
	end

	return ""
end

local function file_type()
	local ft = vim.bo.filetype
	if ft == "" then
		return " \u{f15b} " -- nf-fa-file_o
	end

	return (filetype_icons[ft] or " \u{f15b} ") .. ft
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

	return " \u{f016} " .. size_str .. " " -- nf-fa-file_o
end

local function mode_icon()
	local mode = vim.fn.mode()
	return mode_icons[mode] or (" \u{f059} " .. mode)
end

function M.render_active()
	return table.concat({
		"  ",
		"%#StatusLineBold#",
		mode_icon(),
		"%#StatusLine#",
		" \u{e0b1} %f %h%m%r",
		git_branch(),
		"\u{e0b1} ",
		file_type(),
		"\u{e0b1} ",
		file_size(),
		"%=",
		" \u{f017} %l:%c  %P ",
	})
end

function M.render_inactive()
	return table.concat({
		"  %f %h%m%r ",
		"\u{e0b1} ",
		file_type(),
		" %=  %l:%c   %P ",
	})
end

function M.setup()
	if M._did_setup then
		return
	end
	M._did_setup = true

	vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })

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
