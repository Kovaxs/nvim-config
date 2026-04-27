local M = {}

local state = {
	buf = nil,
	win = nil,
}

local function valid_buf(buf)
	return buf and vim.api.nvim_buf_is_valid(buf)
end

local function valid_win(win)
	return win and vim.api.nvim_win_is_valid(win)
end

local function close_window()
	if valid_win(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end

	state.win = nil
end

local function open_window()
	local width = math.floor(vim.o.columns * 0.9)
	local height = math.floor(vim.o.lines * 0.9)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	state.win = vim.api.nvim_open_win(state.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})
end

local function toggle_lazygit()
	if vim.fn.executable("lazygit") == 0 then
		vim.notify("lazygit is not installed", vim.log.levels.ERROR)
		return
	end

	if valid_win(state.win) then
		close_window()
		return
	end

	if not valid_buf(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = "hide"
		open_window()

		vim.fn.termopen("lazygit", {
			on_exit = function()
				close_window()
				state.buf = nil
			end,
		})
	else
		open_window()
	end

	vim.cmd("startinsert")
end

function M.setup()
	vim.keymap.set("n", "<leader>gl", toggle_lazygit, { desc = "Git: Lazygit toggle" })
end

return M
