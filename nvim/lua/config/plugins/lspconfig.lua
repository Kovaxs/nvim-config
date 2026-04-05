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
			focusable = true,
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

local function setup_keymaps()
	local augroup = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end

			local bufnr = ev.buf
			local opts = { noremap = true, silent = true, buffer = bufnr }

			vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))

			vim.keymap.set("n", "<leader>lf", function()
				require("fzf-lua").lsp_finder()
			end, vim.tbl_extend("force", opts, { desc = "LSP Finder" }))

			vim.keymap.set("n", "<leader>lD", function()
				vim.cmd("vsplit")
				vim.lsp.buf.definition()
			end, vim.tbl_extend("force", opts, { desc = "Definitions (vsplit)" }))

			vim.keymap.set("n", "<leader>ld", function()
				require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
			end, vim.tbl_extend("force", opts, { desc = "Definitions" }))

			vim.keymap.set("n", "<leader>lT", function()
				require("fzf-lua").lsp_declarations()
			end, vim.tbl_extend("force", opts, { desc = "Declarations" }))

			vim.keymap.set("n", "<leader>lr", function()
				require("fzf-lua").lsp_references()
			end, vim.tbl_extend("force", opts, { desc = "References" }))

			vim.keymap.set("n", "<leader>li", function()
				require("fzf-lua").lsp_implementations()
			end, vim.tbl_extend("force", opts, { desc = "Implementations" }))

			vim.keymap.set("n", "<leader>lt", function()
				require("fzf-lua").lsp_typedefs()
			end, vim.tbl_extend("force", opts, { desc = "Type Definitions" }))

			vim.keymap.set("n", "<leader>lb", function()
				require("fzf-lua").lsp_type_sub()
			end, vim.tbl_extend("force", opts, { desc = "Sub Types" }))

			vim.keymap.set("n", "<leader>lu", function()
				require("fzf-lua").lsp_type_super()
			end, vim.tbl_extend("force", opts, { desc = "Super Types" }))

			vim.keymap.set("n", "<leader>ls", function()
				require("fzf-lua").lsp_document_symbols()
			end, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))

			vim.keymap.set("n", "<leader>lS", function()
				require("fzf-lua").lsp_workspace_symbols()
			end, vim.tbl_extend("force", opts, { desc = "Workspace Symbols" }))

			vim.keymap.set("n", "<leader>lw", function()
				require("fzf-lua").lsp_live_workspace_symbols()
			end, vim.tbl_extend("force", opts, { desc = "Live Workspace Symbols" }))

			vim.keymap.set("n", "<leader>lc", function()
				require("fzf-lua").lsp_incoming_calls()
			end, vim.tbl_extend("force", opts, { desc = "Incoming Calls" }))

			vim.keymap.set("n", "<leader>lC", function()
				require("fzf-lua").lsp_outgoing_calls()
			end, vim.tbl_extend("force", opts, { desc = "Outgoing Calls" }))
		end,
	})
end

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
	vim.lsp.config("ruff", {
		init_options = {
			settings = {
				hover = false,
			},
		},
	})
	vim.lsp.config("bashls", {})
	vim.lsp.config("ts_ls", {})
	vim.lsp.config("gopls", {})
	vim.lsp.config("clangd", {})
	vim.lsp.config("rust_analyzer", {})
	vim.lsp.config("nil_ls", {})
	vim.lsp.config("zls", {})

	local to_enable = {
		"lua_ls", -- Lua
		"ty", -- Python
		"ruff", -- Python (code actions / lint)
		"bashls", -- Bash / shell
		"ts_ls", -- TypeScript / JavaScript
		"gopls", -- Go
		"clangd", -- C / C++
		"rust_analyzer", -- Rust
		"nil_ls", -- Nix
		"zls", -- Zig
	}

	vim.lsp.enable(to_enable)
end

function M.setup()
	setup_diagnostics()
	setup_keymaps()
	setup_servers()
end

return M
