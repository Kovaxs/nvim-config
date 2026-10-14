local m = {}

m.spec = {
	src = "https://github.com/Julian/lean.nvim",
}

function m.setup()
	vim.g.lean_config = { mappings = true }
end

return m
