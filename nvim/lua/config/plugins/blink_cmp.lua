local M = {}

M.spec = {
	src = "https://github.com/saghen/blink.cmp",
	version = vim.version.range("1.*"),
}

function M.setup()
	local ok, blink = pcall(require, "blink.cmp")
	if not ok then
		return
	end

	blink.setup({
		-- keymap = {
		-- 	preset = "none",
		-- 	["<C-Space>"] = { "show", "hide" },
		-- 	["<CR>"] = { "accept", "fallback" },
		-- 	["<C-j>"] = { "select_next", "fallback" },
		-- 	["<C-k>"] = { "select_prev", "fallback" },
		-- 	["<Tab>"] = { "snippet_forward", "fallback" },
		-- 	["<S-Tab>"] = { "snippet_backward", "fallback" },
		-- },
		-- appearance = { nerd_font_variant = "mono" },
		completion = { menu = { auto_show = true } },
		sources = { default = { "lsp", "path", "buffer", "snippets" } },
		snippets = {
			preset = "luasnip",
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
		},
		fuzzy = {
			implementation = "prefer_rust",
			prebuilt_binaries = { download = true },
		},
	})
end

return M
