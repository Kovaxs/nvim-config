vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
	callback = function(ev)
		-- local map = function(keys, func, desc)
		--     vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
		-- end
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
		end
		-- The following two autocommands are used to highlight references of the
		-- word under your cursor when your cursor rests there for a little while.
		--    See `:help CursorHold` for information about when this is executed
		--
		-- When you move your cursor, the highlights will be cleared (the second autocommand).
		if client and client.server_capabilities.documentHighlightProvider then
			local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = ev.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})

			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = ev.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
				end,
			})
		end

		-- The following autocommand is used to enable inlay hints in your
		-- code, if the language server you are using supports them
		--
		-- This may be unwanted, since they displace some of your code
		-- if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
		--     map("<leader>th", function()
		--         vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		--     end, "[T]oggle Inlay [H]ints")
		-- end

		-- Format the current buffer on save
		-- vim.api.nvim_create_autocmd('BufWritePre', {
		--     buffer = ev.buf,
		--     callback = function()
		--         vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
		--     end,
		-- })
	end,
})

vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	root_markers = { ".git" },
})

vim.diagnostic.config({ virtual_lines = { current_line = true } })

vim.lsp.enable({ "pyright", "ruff" })
vim.lsp.enable("lua_ls")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
-- vim.lsp.enable("postgres_lsp")
vim.lsp.enable("ts_ls")
vim.lsp.enable("astro")
