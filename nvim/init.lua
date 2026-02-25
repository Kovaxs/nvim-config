print("advent of neovim")

-- 1. Load Plugin Manager First
require("config.lazy")

-- ==========================================
-- 2. GENERAL SETTINGS (vim.opt)
-- ==========================================

-- Time Managers
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- Session Management
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.cmdheight = 1

-- Spell check
vim.opt.spelllang = "en_us"
vim.opt.spell = true
-- vim.g.spellfile_URL is usually handled automatically by Neovim now

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs & Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.softtabstop = 4

-- Line Wrapping
vim.opt.wrap = false

-- Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Cursor Line & Appearance
vim.opt.cursorline = true
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "89"

vim.diagnostic.config({
	float = { border = "rounded" },
})

-- Performance & Files
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.updatetime = 50

-- Misc behavior
vim.opt.backspace = "indent,eol,start"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.isfname:append("@-@")
vim.opt.scrolloff = 8

-- Folding (Native Neovim 0.10+ Treesitter folding)
vim.opt.foldlevel = 20
vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- ==========================================
-- 3. KEYMAPS
-- ==========================================

require("core.keymaps") -- Load your external keymaps

-- Continuous visual mode indentation (Modern API)
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true, desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true, desc = "Indent right" })

-- Custom Terminal Keymaps
local job_id = 0
vim.keymap.set("n", "<space>ot", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 5)
	job_id = vim.bo.channel
end, { desc = "Terminal: toggle terminal" })

local current_command = ""
vim.keymap.set("n", "<space>te", function()
	current_command = vim.fn.input("Command: ")
end, { desc = "Terminal: save command to run in terminal" })

vim.keymap.set("n", "<space>tr", function()
	if current_command == "" then
		current_command = vim.fn.input("Command: ")
	end

	if job_id ~= 0 then
		vim.fn.chansend(job_id, { current_command .. "\r\n" })
	else
		print("No terminal open! Press <space>ot first.")
	end
end, { desc = "Terminal: run a saved command" })

-- ==========================================
-- 4. AUTOCOMMANDS
-- ==========================================

-- Highlight when yanking
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Terminal styling (use opt_local so it doesn't break normal buffers)
vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
	end,
})

-- Merged Treesitter Setup (Highlighting and Indentation)
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true }),
	callback = function(args)
		-- 1. Enable syntax highlighting safely
		pcall(vim.treesitter.start, args.buf)

		-- 2. Enable treesitter-based indentation safely
		pcall(function()
			vim.bo[args.buf].indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end)
	end,
})

-- ==========================================
-- 5. PLUGIN INITIALIZATION
-- ==========================================
-- Tip: In the future, it is best practice to move these setups into
-- your `lazy.nvim` plugin files so Lazy can manage loading them!
require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/LuaSnip/" } })
require("mini.surround").setup()
require("mini.pairs").setup()
