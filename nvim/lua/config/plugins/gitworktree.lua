return {
	'ThePrimeagen/git-worktree.nvim',
	keys = {
		{
			"<leader>gr",
			function()
				local output = vim.fn.systemlist("git worktree list --porcelain")
				if vim.v.shell_error ~= 0 then
					vim.notify("Failed to list git worktrees", vim.log.levels.ERROR)
					return
				end

				local worktrees = {}
				for _, line in ipairs(output) do
					if vim.startswith(line, "worktree ") then
						table.insert(worktrees, line:sub(10))
					end
				end

				if #worktrees == 0 then
					vim.notify("No git worktrees found", vim.log.levels.INFO)
					return
				end

				vim.ui.select(worktrees, { prompt = "Select worktree" }, function(choice)
					if not choice then
						return
					end
					require("git-worktree").switch_worktree(choice)
				end)
			end,
			desc = "Show and switch worktrees",
		},
		{
			"<leader>gR",
			function()
				vim.ui.input({ prompt = "Worktree path: " }, function(path)
					if not path or path == "" then
						return
					end

					vim.ui.input({ prompt = "Branch name: " }, function(branch)
						if not branch or branch == "" then
							return
						end

						vim.ui.input({ prompt = "Upstream (default: origin): " }, function(upstream)
							require("git-worktree").create_worktree(path, branch, upstream ~= "" and upstream or nil)
						end)
					end)
				end)
			end,
			desc = "Create worktree",
		},
	},
	config = function()
		require("git-worktree").setup()
	end,
}
