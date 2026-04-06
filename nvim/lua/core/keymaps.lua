-- lua commands
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source: source nvim" })
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Lua: Run current line" })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Lua: Run currently selected lines" })
vim.keymap.set("n", "<leader>yp", " :let @+ = expand('%:p')<CR>", { desc = "Yank current buffer path" })

-- Tmux new session
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ts<CR>")

-- better movement in wrapped text
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })

-- Buffer moves
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

-- Better clipboard interaction
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard registry" })
vim.keymap.set("n", "<leader>bp", '"+p')
vim.keymap.set("v", "<leader>bp", '"+p')
vim.keymap.set("n", "<leader>bP", '"+P')

-- copy/yank stuff
vim.keymap.set("n", "<leader>yp", function() -- show file path
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy full file path" })

vim.keymap.set("n", "<leader>en", function()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not available", vim.log.levels.WARN)
		return
	end

	fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Picker: nvim config files" })

vim.keymap.set("n", "<leader>ee", function()
	local ok, fzf = pcall(require, "fzf-lua")
	if not ok then
		vim.notify("fzf-lua is not available", vim.log.levels.WARN)
		return
	end

	fzf.files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "site", "pack", "core", "opt") })
end, { desc = "Picker: installed package files" })

local terminal = {
	buf = nil,
	win = nil,
	job = nil,
	command = "",
}

local function valid_buf(buf)
	return buf and vim.api.nvim_buf_is_valid(buf)
end

local function valid_win(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function open_terminal()
	if valid_win(terminal.win) and vim.api.nvim_win_get_buf(terminal.win) == terminal.buf then
		vim.api.nvim_set_current_win(terminal.win)
		vim.cmd("startinsert")
		return
	end

	vim.cmd("botright split")
	vim.api.nvim_win_set_height(0, 7)

	if valid_buf(terminal.buf) then
		vim.api.nvim_win_set_buf(0, terminal.buf)
	else
		vim.cmd("terminal")
		terminal.buf = vim.api.nvim_get_current_buf()
	end

	terminal.win = vim.api.nvim_get_current_win()
	if valid_buf(terminal.buf) then
		terminal.job = vim.bo[terminal.buf].channel
	end

	vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>ot", function()
	if valid_win(terminal.win) and vim.api.nvim_win_get_buf(terminal.win) == terminal.buf then
		vim.api.nvim_win_close(terminal.win, true)
		terminal.win = nil
		return
	end

	open_terminal()
end, { desc = "Terminal: Toggle" })

vim.keymap.set("n", "<leader>oe", function()
	terminal.command = vim.fn.input("Command: ")
end, { desc = "Terminal: Save command" })

vim.keymap.set("n", "<leader>or", function()
	if terminal.command == "" then
		terminal.command = vim.fn.input("Command: ")
	end

	if terminal.command == "" then
		return
	end

	open_terminal()

	local job = terminal.job
	if valid_buf(terminal.buf) then
		job = vim.bo[terminal.buf].channel
		terminal.job = job
	end

	if job and job > 0 then
		vim.fn.chansend(job, { terminal.command, "\r\n" })
	else
		vim.notify("No terminal open. Use <leader>ot first.", vim.log.levels.WARN)
	end
end, { desc = "Terminal: Run command" })

-- Diagnostic
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
vim.keymap.set("n", "<leader>te", function()
	vim.diagnostic.open_float({ border = "rounded", focus = true })
end, { desc = "Show diagnostic in floating window" })
vim.keymap.set("n", "<leader>tl", function()
	vim.diagnostic.setloclist()
end, { desc = "LSP: Set local diagnostic list" })
vim.keymap.set("n", "<leader>tq", function()
	vim.diagnostic.setqflist()
end, { desc = "LSP: Local diagnostic list to quickfix list" })

-- Add current line to the Quickfix List
vim.keymap.set(
	"n",
	"<leader>qq",
	':caddexpr expand("%") . ":" . line(".") . ":" . getline(".")<CR>',
	{ desc = "Add line to Quickfix" }
)

-- Add current line to the Location List
vim.keymap.set(
	"n",
	"<leader>ql",
	':laddexpr expand("%") . ":" . line(".") . ":" . getline(".")<CR>',
	{ desc = "Add line to Location List" }
)

-- Toggle numbers
vim.keymap.set("n", "<leader>hn", function()
	local number = vim.wo.number
	vim.wo.number = not number
	vim.wo.relativenumber = not number
end, { desc = "Toggle line numbers" })

-- Change language
vim.keymap.set("n", "<leader>cl", function()
	local current = vim.bo.spelllang
	local next_lang = current:match("^es") and "en" or "es"
	vim.cmd("setlocal spelllang=" .. next_lang)
end, { desc = "Toggle spell language en/es" })
