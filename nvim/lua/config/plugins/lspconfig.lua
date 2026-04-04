local M = {}

M.spec = {
	src = "https://github.com/neovim/nvim-lspconfig",
}

local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}

local function lsp_capabilities()
	local ok, blink = pcall(require, "blink.cmp")
	if ok and type(blink.get_lsp_capabilities) == "function" then
		return blink.get_lsp_capabilities()
	end

	return vim.lsp.protocol.make_client_capabilities()
end

local function setup_diagnostics()
	vim.diagnostic.config({
		virtual_text = { prefix = "●", spacing = 4 },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
				[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
				[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
				[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
			},
		},
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
			focusable = false,
			style = "minimal",
		},
	})

	local orig = vim.lsp.util.open_floating_preview
	vim.lsp.util.open_floating_preview = function(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

-- keymaps
-- local function setup_keymaps()
-- 	local augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
--
-- 	vim.api.nvim_create_autocmd("LspAttach", {
-- 		group = augroup,
-- 		callback = function(ev)
-- 			local client = vim.lsp.get_client_by_id(ev.data.client_id)
-- 			if not client then
-- 				return
-- 			end

			-- local bufnr = ev.buf
			-- local opts = { noremap = true, silent = true, buffer = bufnr }

	-- 		vim.keymap.det("n", "<leader>gd", function()
	-- 			require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP definitions" }))
	--
	-- 		vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "LSP definition" }))
	--
	-- 		vim.keymap.set("n", "<leader>gS", function()
	-- 			vim.cmd("vsplit")
	-- 			vim.lsp.buf.definition()
	-- 		end, vim.tbl_extend("force", opts, { desc = "Definition in split" }))
	--
	-- 		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
	-- 		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
	--
	-- 		vim.keymap.set("n", "<leader>D", function()
	-- 			vim.diagnostic.open_float({ scope = "line" })
	-- 		end, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
	--
	-- 		vim.keymap.set("n", "<leader>d", function()
	-- 			vim.diagnostic.open_float({ scope = "cursor" })
	-- 		end, vim.tbl_extend("force", opts, { desc = "Cursor diagnostics" }))
	--
	-- 		vim.keymap.set("n", "<leader>nd", function()
	-- 			vim.diagnostic.jump({ count = 1 })
	-- 		end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
	--
	-- 		vim.keymap.set("n", "<leader>pd", function()
	-- 			vim.diagnostic.jump({ count = -1 })
	-- 		end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
	--
	-- 		vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
	--
	-- 		vim.keymap.set("n", "<leader>fr", function()
	-- 			require("fzf-lua").lsp_references()
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP references" }))
	--
	-- 		vim.keymap.set("n", "<leader>ft", function()
	-- 			require("fzf-lua").lsp_typedefs()
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP type defs" }))
	--
	-- 		vim.keymap.set("n", "<leader>fs", function()
	-- 			require("fzf-lua").lsp_document_symbols()
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP document symbols" }))
	--
	-- 		vim.keymap.set("n", "<leader>fw", function()
	-- 			require("fzf-lua").lsp_workspace_symbols()
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP workspace symbols" }))
	--
	-- 		vim.keymap.set("n", "<leader>fi", function()
	-- 			require("fzf-lua").lsp_implementations()
	-- 		end, vim.tbl_extend("force", opts, { desc = "LSP implementations" }))
	--
	-- 		if client:supports_method("textDocument/codeAction", bufnr) then
	-- 			vim.keymap.set("n", "<leader>oi", function()
	-- 				vim.lsp.buf.code_action({
	-- 					context = { only = { "source.organizeImports" }, diagnostics = {} },
	-- 					apply = true,
	-- 					bufnr = bufnr,
	-- 				})
	-- 			end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
	-- 		end
	-- 	end,
	-- })
	--
	-- vim.keymap.set("n", "<leader>q", function()
	-- 	vim.diagnostic.setloclist({ open = true })
	-- end, { desc = "Open diagnostic list" })
	--
	-- vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
-- end

local function setup_servers()
	vim.lsp.config("*", {
		capabilities = lsp_capabilities(),
	})

	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				telemetry = { enable = false },
			},
		},
	})

	vim.lsp.config("ty", {})
	vim.lsp.config("bashls", {})
	vim.lsp.config("ts_ls", {})
	vim.lsp.config("gopls", {})
	vim.lsp.config("clangd", {})
	vim.lsp.config("rust_analyzer", {})
	vim.lsp.config("zls", {})

	local to_enable = {
		"lua_ls", -- Lua
		"ty", -- Python
		"bashls", -- Bash / shell
		"ts_ls", -- TypeScript / JavaScript
		"gopls", -- Go
		"clangd", -- C / C++
		"rust_analyzer", -- Rust
		"zls", -- Zig
	}

	vim.lsp.enable(to_enable)
end

function M.setup()
	setup_diagnostics()
	-- setup_keymaps()
	setup_servers()
end

return M
