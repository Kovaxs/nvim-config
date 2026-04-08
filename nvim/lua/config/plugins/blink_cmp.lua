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
		signature = { enabled = true },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 500 },
			menu = {
				auto_show = true,
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
				},
			},
		},
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
