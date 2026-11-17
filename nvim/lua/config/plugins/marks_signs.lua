-- Shows set marks (a-z, A-Z) as a letter in the sign column of their line.
local M = {}

local ns = vim.api.nvim_create_namespace("marks_signs")
local keys_ns = vim.api.nvim_create_namespace("marks_signs_keys")

local letters = {}
for c in ("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):gmatch(".") do
	table.insert(letters, c)
end

---@param buf integer
local function refresh(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
	local line_count = vim.api.nvim_buf_line_count(buf)

	---@param letter string
	---@param lnum integer 1-based, 0 when unset
	local function place(letter, lnum)
		if lnum > 0 and lnum <= line_count then
			vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
				sign_text = letter .. " ",
				sign_hl_group = "MarksSignsHl",
				priority = 10,
			})
		end
	end

	for _, letter in ipairs(letters) do
		if letter:match("%l") then
			-- buffer-local mark; row is 0 when unset
			place(letter, vim.api.nvim_buf_get_mark(buf, letter)[1])
		else
			-- file mark; getpos gives { bufnum, lnum, col, off }
			local pos = vim.fn.getpos("'" .. letter)
			if pos[1] == buf then
				place(letter, pos[2])
			end
		end
	end
end

local function refresh_current()
	refresh(vim.api.nvim_get_current_buf())
end

function M.setup()
	vim.api.nvim_set_hl(0, "MarksSignsHl", { link = "Special", default = true })

	local group = vim.api.nvim_create_augroup("MarksSigns", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = function()
			vim.api.nvim_set_hl(0, "MarksSignsHl", { link = "Special", default = true })
		end,
	})
	vim.api.nvim_create_autocmd({
		"BufEnter",
		"BufLeave",
		"TextChanged",
		"InsertLeave",
		"CursorMoved",
		"CursorHold",
		"CmdlineLeave",
	}, {
		group = group,
		callback = refresh_current,
	})

	-- Setting a mark (m + letter) does not move the cursor or fire an autocmd,
	-- so watch the typed keys and refresh right after an 'm' + letter pair.
	local pending_m = false
	vim.on_key(function(_, typed)
		if pending_m and typed:match("^%a$") then
			vim.schedule(refresh_current)
		end
		pending_m = typed == "m"
	end, keys_ns)

	refresh_current()
end

return M
