local M = {}

M.spec = {
	src = "https://github.com/lewis6991/gitsigns.nvim",
}

function M.setup()
	local ok, gitsigns = pcall(require, "gitsigns")
	if not ok then
		return
	end

	gitsigns.setup({
		signs = {
			add = { text = "\u{2590}" },
			change = { text = "\u{2590}" },
			delete = { text = "\u{2590}" },
			topdelete = { text = "\u{25e6}" },
			changedelete = { text = "\u{25cf}" },
			untracked = { text = "\u{25cb}" },
		},
		signcolumn = true,
		current_line_blame = false,
	})

	vim.keymap.set("n", "]h", function()
		if vim.wo.diff then
			return "]h"
		end
		vim.schedule(function()
			gitsigns.next_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "Next git hunk" })

	vim.keymap.set("n", "[h", function()
		if vim.wo.diff then
			return "[h"
		end
		vim.schedule(function()
			gitsigns.prev_hunk()
		end)
		return "<Ignore>"
	end, { expr = true, desc = "Previous git hunk" })

	vim.keymap.set("n", "<leader>gb", function()
		gitsigns.blame_line({ full = true })
	end, { desc = "Blame line" })

	vim.keymap.set("n", "<leader>gB", function()
		gitsigns.toggle_current_line_blame()
	end, { desc = "Toggle inline blame" })

	vim.keymap.set("n", "<leader>gd", function()
		gitsigns.diffthis()
	end, { desc = "Diff this" })
end

return M
