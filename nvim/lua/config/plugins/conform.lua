local M = {}

M.spec = {
	src = "https://github.com/stevearc/conform.nvim",
}

function M.setup()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return
	end

	conform.setup({
		formatters_by_ft = {
			c = { "clang_format" },
			cpp = { "clang_format" },
			css = { "prettierd" },
			go = { "gofumpt", "goimports" },
			html = { "prettierd" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd" },
			mojo = { "mojo_format" },
			nix = { "alejandra", "nixfmt" },
			python = { "ruff_format" },
			sh = { "shfmt" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			terraform = { "terraform_fmt" },
			tf = { "terraform_fmt" },
		},
		formatters = {
			-- `mojo format` only works on files, so conform writes the buffer to a temp file first.
			mojo_format = {
				command = "mojo",
				args = { "format", "$FILENAME" },
				stdin = false,
			},
			-- Prefer the project's uv venv ruff, fall back to Mason/PATH.
			ruff_format = {
				command = require("conform.util").find_executable({ ".venv/bin/ruff" }, "ruff"),
			},
		},
		format_on_save = {
			timeout_ms = 2000,
			lsp_format = "fallback",
		},
	})
end

return M
