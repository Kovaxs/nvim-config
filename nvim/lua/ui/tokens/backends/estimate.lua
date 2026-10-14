-- Token count backend contract:
--   name      : string
--   available : function() -> boolean
--   exact     : boolean (may be false for estimates)
--   count     : function(text, cb) -> nil
--               cb(count, err) MUST be called asynchronously, never inline.

local M = {}

M.name = "estimate"
M.exact = false

function M.available()
	return true
end

--- Rough token estimate: ~4 chars per token.
---@param text string
---@param cb fun(count: number|nil, err: string|nil)
function M.count(text, cb)
	local chars = #text
	vim.schedule(function()
		cb(math.max(1, math.floor(chars / 4)), nil)
	end)
end

return M
