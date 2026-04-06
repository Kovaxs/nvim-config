-- GitDiff
vim.api.nvim_create_user_command("GitDiff", function(opts)
	-- 1. Check for an argument. If empty, default to "HEAD"
	local commit = opts.args == "" and "HEAD" or opts.args

	local current_file = vim.api.nvim_buf_get_name(0)
	if current_file == "" then
		vim.notify("Not a valid file to diff", vim.log.levels.ERROR)
		return
	end

	local relative_file = vim.fn.fnamemodify(current_file, ":~:.")

	-- 2. Pass the 'commit' variable to the git command instead of hardcoding HEAD
	local git_output = vim.system({ "git", "show", commit .. ":" .. relative_file }, { text = true }):wait()

	if git_output.code ~= 0 then
		vim.notify("File not in Git or commit '" .. commit .. "' not found", vim.log.levels.WARN)
		return
	end

	local temp_file = vim.fn.tempname()
	local f = io.open(temp_file, "w")
	if f then
		f:write(git_output.stdout)
		f:close()
	end

	vim.cmd("packadd nvim.difftool")
	require("difftool").open(temp_file, current_file)
end, {
	nargs = "?", -- '?' means the command accepts zero or one argument
	desc = "Git diff current file against a specific commit or HEAD",
})

-- Map the leader key to type the command for you, leaving a space for the argument
vim.keymap.set("n", "<leader>gd", ":GitDiff<CR>", { desc = "Git diff with DiffTool (type commit or press Enter)" })
vim.keymap.set("n", "<leader>gD", ":GitDiff ", { desc = "Git diff with DiffTool (type commit or press Enter)" })
