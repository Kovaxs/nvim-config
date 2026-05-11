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

local function close_split()
	if valid_win(state.win) then
		vim.api.nvim_win_close(state.win, true)
	end

	state.win = nil
end

local function open_split()
	local width = math.floor(vim.o.columns * 0.4)
	local fresh = false

	if not valid_buf(state.buf) then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[state.buf].bufhidden = "hide"
		fresh = true
	end

	vim.cmd("vsplit")
	vim.api.nvim_win_set_width(0, width)
	vim.api.nvim_win_set_buf(0, state.buf)
	state.win = vim.api.nvim_get_current_win()

	if fresh then
		vim.fn.termopen("pi", {
			on_exit = function()
				close_split()
				state.buf = nil
			end,
		})
	else
		-- Trigger TUI redraw on existing job
		local job_id = vim.b[state.buf].terminal_job_id
		if job_id then
			vim.fn.termresize(job_id, width, vim.o.lines)
		end
	end
end

local function toggle_pi()
	if vim.fn.executable("pi") == 0 then
		vim.notify("pi is not installed", vim.log.levels.ERROR)
		return
	end

	if valid_win(state.win) then
		close_split()
		return
	end

	open_split()

	vim.cmd("startinsert")
end

function M.setup()
	vim.keymap.set("n", "<leader>oo", toggle_pi, { desc = "Pi: Toggle dev tool" })
end

return M
