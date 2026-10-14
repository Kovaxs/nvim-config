-- Async token counter for the statusline.
--
-- Counts tokens for tracked buffers (markdown by default, or every normal
-- buffer with all = true) using a pluggable backend. Results are cached
-- per-buffer in vim.b[buf].token_count so the statusline render function only
-- ever reads a table.
--
-- Backends live in ui/tokens/backends/<name>.lua and must call their callback
-- asynchronously (see backends/estimate.lua for the contract).

local M = {}

--- Format a raw count into a short string: 980 -> "980", 1183 -> "1.18k"
---@param n number
---@return string
local function short(n)
	if n < 1000 then
		return tostring(n)
	end
	if n < 1000 * 1000 then
		return string.format("%.2fk", n / 1000)
	end
	return string.format("%.2fM", n / (1000 * 1000))
end

-- --------------------------------------------------------------------------------
-- State
-- --------------------------------------------------------------------------------

local defaults = {
	backend = "estimate",
	fallback = "estimate",
	filetypes = { markdown = true },
	-- all = true counts every normal buffer, ignoring filetypes (exclude still applies)
	all = false,
	-- filetypes never counted, even with all = true
	exclude = {
		"help",
		"qf",
		"loclist",
		"prompt",
		"nofile",
		"oil",
		"terminal",
		"TelescopePrompt",
		"NvimTree",
	},
	debounce_ms = 500,
	max_bytes = 1024 * 1024,
	icon = " \u{f295} ", -- nf-md-abacus
}

M.config = vim.deepcopy(defaults)

local timers = {} -- buffer -> uv_timer_t
local pending = {} -- buffer -> request id
local excluded = {} -- filetype -> true (built in setup from M.config.exclude)

-- --------------------------------------------------------------------------------
-- Filetype filter
-- --------------------------------------------------------------------------------

--- Should this filetype be counted?
---@param ft string
---@return boolean
local function tracked(ft)
	if excluded[ft] then
		return false
	end
	if M.config.all then
		return true
	end
	return M.config.filetypes[ft] == true
end

--- Should this buffer be counted? Skips special buffers (terminal, prompt,
--- nofile, quickfix, ...) in addition to the filetype filter.
---@param buf number
---@return boolean
local function tracked_buf(buf)
	if not vim.api.nvim_buf_is_valid(buf) then
		return false
	end
	if vim.bo[buf].buftype ~= "" then
		return false
	end
	return tracked(vim.bo[buf].filetype)
end

-- --------------------------------------------------------------------------------
-- Backend resolution
-- --------------------------------------------------------------------------------

local function require_backend(name)
	if not name then
		return nil
	end
	local ok, backend = pcall(require, "ui.tokens.backends." .. name)
	if not ok or type(backend) ~= "table" or type(backend.count) ~= "function" then
		vim.notify("tokens: bad backend '" .. tostring(name) .. "'", vim.log.levels.WARN)
		return nil
	end
	if backend.available and not backend.available() then
		return nil
	end
	return backend
end

--- Resolve the backend for a filetype, preferring the configured one and
--- falling back to M.config.fallback when unavailable.
---@param name string|nil
---@return table|nil
local function resolve(name)
	return require_backend(name) or require_backend(M.config.fallback)
end

-- --------------------------------------------------------------------------------
-- Counting
-- --------------------------------------------------------------------------------

--- Byte length of a buffer without materializing its text.
---@param buf number
---@return number
local function buf_bytes(buf)
	local last = vim.api.nvim_buf_line_count(buf)
	return vim.api.nvim_buf_get_offset(buf, last - 1) + #vim.api.nvim_buf_get_lines(buf, last - 1, last, false)[1]
end

--- Read buffer text, or nil when it is too large.
---@param buf number
---@return string|nil
local function buf_text(buf)
	if buf_bytes(buf) > M.config.max_bytes then
		return nil
	end
	return table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
end

--- Store a finished count and repaint the statusline.
---@param buf number
---@param req number
---@param count number|nil
---@param backend table|nil
local function finish(buf, req, count, backend)
	if not vim.api.nvim_buf_is_valid(buf) or pending[buf] ~= req then
		return -- stale result
	end
	pending[buf] = nil

	if count then
		vim.b[buf].token_count = { n = count, exact = backend.exact ~= false, backend = backend.name }
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(buf) then
				vim.cmd.redrawstatus()
			end
		end)
	end
end

--- Start an async count for buf. Safe to call repeatedly.
---@param buf number
function M.refresh(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not tracked_buf(buf) then
		return
	end

	local text = buf_text(buf)
	if not text then
		return -- too large: keep the previous value
	end

	local req = (pending[buf] or 0) + 1
	pending[buf] = req

	local backend = resolve(M.config.backend)
	if not backend then
		pending[buf] = nil
		return
	end

	local ok = pcall(backend.count, text, function(count, err)
		if err or not count then
			local fb = require_backend(M.config.fallback)
			if fb then
				pcall(fb.count, text, function(c2, e2)
					if c2 and not e2 then
						vim.schedule(function()
							finish(buf, req, c2, fb)
						end)
					end
				end)
			end
			return
		end
		vim.schedule(function()
			finish(buf, req, count, backend)
		end)
	end)
	if not ok then
		pending[buf] = nil
	end
end

--- Debounced refresh, used by edit autocmds.
---@param buf number
function M.refresh_debounced(buf)
	buf = buf or vim.api.nvim_get_current_buf()
	if not tracked_buf(buf) then
		return
	end

	local timer = timers[buf]
	if not timer then
		timer = assert(vim.uv.new_timer())
		timers[buf] = timer
	end

	-- Invalidate any in-flight count: the buffer changed since it started.
	pending[buf] = (pending[buf] or 0) + 1

	timer:stop()
	timer:start(M.config.debounce_ms, 0, function()
		timer:stop()
		vim.schedule(function()
			M.refresh(buf)
		end)
	end)
end

-- --------------------------------------------------------------------------------
-- Statusline API
-- --------------------------------------------------------------------------------

--- Cached token string for the current window's buffer. Returns "" when the
--- buffer is not tracked or no count exists yet.
---@return string
function M.statusline()
	local buf = vim.api.nvim_get_current_buf()
	if not tracked_buf(buf) then
		return ""
	end

	local cached = vim.b[buf].token_count
	if not cached then
		return ""
	end

	local prefix = cached.exact and "" or "~"
	return M.config.icon .. prefix .. short(cached.n) .. " tok "
end

-- --------------------------------------------------------------------------------
-- Setup
-- --------------------------------------------------------------------------------

local function cleanup(buf)
	local timer = timers[buf]
	if timer then
		if not timer:is_closing() then
			timer:stop()
			timer:close()
		end
		timers[buf] = nil
	end
	pending[buf] = nil
end

--- @param opts table|nil see M.config for keys
function M.setup(opts)
	if M._did_setup then
		return
	end
	M._did_setup = true

	opts = opts or {}
	-- Accept both list form { "markdown", "org" } and map form { markdown = true }.
	if type(opts.filetypes) == "table" then
		local fts = {}
		for key, value in pairs(opts.filetypes) do
			if type(key) == "number" then
				fts[value] = true
			else
				fts[key] = value
			end
		end
		opts.filetypes = fts
	end
	M.config = vim.tbl_deep_extend("force", defaults, opts)

	excluded = {}
	for _, ft in ipairs(M.config.exclude) do
		excluded[ft] = true
	end

	local group = vim.api.nvim_create_augroup("StatuslineTokens", { clear = true })

	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "FileType" }, {
		group = group,
		callback = function(ev)
			if tracked_buf(ev.buf) then
				M.refresh(ev.buf)
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "InsertLeave" }, {
		group = group,
		callback = function(ev)
			if tracked_buf(ev.buf) then
				M.refresh_debounced(ev.buf)
			end
		end,
	})

	vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
		group = group,
		callback = function(ev)
			cleanup(ev.buf)
		end,
	})

	vim.api.nvim_create_user_command("TokensRefresh", function()
		M.refresh(vim.api.nvim_get_current_buf())
	end, { desc = "Recount tokens for the current buffer" })
end

return M
