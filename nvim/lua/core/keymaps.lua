-- Set leader key to space
-- vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Source: source nvim" })
keymap.set("n", "<leader>x", ":.lua<CR>", { desc = "Lua: Run current line" })
keymap.set("v", "<leader>x", ":lua<CR>", { desc = "Lua: Run currently selected lines" })
keymap.set("n", "<leader>yp", " :let @+ = expand('%:p')<CR>", { desc = "Yank current buffer path" })

-- TODO: search for better alternative to cnex and cprev
-- keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
-- keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Toggle untoggle numbers

-- Map <leader>n to toggle line numbers
vim.keymap.set("n", "<leader>hn", function()
	local number = vim.wo.number
	local guide_lines = Snacks.indent.enabled
	Snacks.indent.enabled = not guide_lines
	vim.wo.number = not number
	vim.wo.relativenumber = not number
end, { desc = "Toggle line numbers" })

-- spell checker change language
keymap.set("n", "<leader>cl", function()
	vim.cmd("setlocal spelllang=" .. (vim.bo.spelllang == "es" and "en" or "es"))
end, { desc = "Toggle spell check language between Spanish and English" })

-- General keymaps
-- keymap.set("i", "kj", "<ESC>")

-- Lazygit
keymap.set("n", "<leader>lg", function()
	Snacks.lazygit()
end, { desc = "Git: Lazygit" })

-- Picker

-- keymap.set("n", "<leader>fT", function()
--     Snacks.picker.todo_comments({ keywords = { "TODO", "FIXME", "FIX" } })
-- end, { desc = "Picker: Todo/Fix/Fixme" })
-- keymap.set("n", "<leader>ft", function()
--     Snacks.picker.todo_comments()
-- end, { desc = "Picker: Todo" })
--

-- keymap.set("n", "<leader>sr", function()
--     Snacks.picker.registers()
-- end, { desc = "Picker: registers" })

-- Special picker
keymap.set("n", "<leader>sp", function()
	Snacks.picker.spelling()
end, { desc = "Picker: search history" })
keymap.set("n", "<leader>sh", function()
	Snacks.picker.search_history()
end, { desc = "Picker: search history" })

keymap.set("n", "<leader>fr", function()
	Snacks.picker.resume()
end, { desc = "Picker: resume" })

keymap.set("n", "<leader>fch", function()
	Snacks.picker.command_history()
end, { desc = "Picker: command history" })

keymap.set("n", "<leader>fcc", function()
	Snacks.picker.commands()
end, { desc = "Picker: commands" })

keymap.set("n", "<leader>fq", function()
	Snacks.picker.qflist()
end, { desc = "Pikcer: quickfix list" })

-- LSP, diagnostic & TS pickers
keymap.set("n", "<leader>ld", function()
	Snacks.picker.lsp_definitions()
end, { desc = "LSP: Go to Definition" })

keymap.set("n", "<leader>lr", function()
	Snacks.picker.lsp_references()
end, { desc = "LSP: Show References" })

keymap.set("n", "<leader>fS", function()
	Snacks.picker.lsp_workspace_symbols()
end, { desc = "Picker: lsp workspace symbols" })

keymap.set("n", "<leader>fs", function()
	Snacks.picker.lsp_symbols()
end, { desc = "Picker: lsp symbols" })

keymap.set("n", "<leader>ft", function()
	Snacks.picker.treesitter()
end, { desc = "TS: picker for current buffer" })

keymap.set("n", "<leader>ed", function()
	Snacks.picker.diagnostics_buffer()
end, { desc = "LSP: Pikcer diagnostic list" })

-- File Explorer
keymap.set("n", "<leader>oe", function()
	Snacks.picker.explorer()
end, { desc = "Picker: Open File Explorer" })

-- Git pikcer
keymap.set("n", "<leader>glf", function()
	Snacks.picker.git_log_file()
end, { desc = "Picker: git log line" })
keymap.set("n", "<leader>gll", function()
	Snacks.picker.git_log_line()
end, { desc = "Picker: git log line" })

keymap.set("n", "<leader>gg", function()
	Snacks.picker.git_grep()
end, { desc = "Picker: git files grep" })

keymap.set("n", "<leader>gf", function()
	Snacks.picker.git_files()
end, { desc = "Picker: git files search" })

-- General pickers: smart, grep, files, help
keymap.set("n", "<leader>ff", function()
	Snacks.picker.smart()
end, { desc = "Picker: smart search" })

keymap.set("n", "<leader>fB", function()
	Snacks.picker.grep()
end, { desc = "Picker: grep open buffers" })

keymap.set("n", "<leader>fa", function()
	Snacks.picker.grep({ hidden = false, ignored = false })
end, { desc = "Picker: live search all in current dir" })

keymap.set("n", "<leader>fd", function()
	Snacks.picker.files()
end, { desc = "Picker: search files" })

-- Help pikcer
keymap.set("n", "<leader>fk", function()
	Snacks.picker.keymaps()
end, { desc = "Help: Kyemaps" })

keymap.set("n", "<leader>fh", function()
	Snacks.picker.help()
end, { desc = "Picker: search help_tags" })

-- Current buffer greps
keymap.set("n", "<leader>*", function()
	Snacks.picker.grep_word()
end, { desc = "Picker: search current word under the cursor" })

keymap.set("n", "<leader>/", function()
	Snacks.picker.lines()
end, { desc = "Picker: search current in buffer lines" })

-- Nvim config picker
keymap.set("n", "<leader>en", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Picker: search in nvim conf dir" })

keymap.set("n", "<leader>ep", function()
	Snacks.picker.files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
end, { desc = "Picker: search in installed packages files" })

-- Refactor
keymap.set({ "n", "x" }, "<leader>rr", function()
	require("telescope").extensions.refactoring.refactors()
end, { desc = "Open refactoring menu" })
-- keymap.set({ "n", "x" }, "<leader>re", function() return require('refactoring').refactor('Extract Function') end,
-- { expr = true })
-- keymap.set({ "n", "x" }, "<leader>rf",
-- function() return require('refactoring').refactor('Extract Function To File') end, { expr = true })
-- keymap.set({ "n", "x" }, "<leader>rv", function() return require('refactoring').refactor('Extract Variable') end,
-- { expr = true })
-- keymap.set({ "n", "x" }, "<leader>rI", function() return require('refactoring').refactor('Inline Function') end,
-- { expr = true })
-- keymap.set({ "n", "x" }, "<leader>ri", function() return require('refactoring').refactor('Inline Variable') end,
-- { expr = true })
--
-- keymap.set({ "n", "x" }, "<leader>rbb", function() return require('refactoring').refactor('Extract Block') end,
-- { expr = true })
-- keymap.set({ "n", "x" }, "<leader>rbf",
--     function() return require('refactoring').refactor('Extract Block To File') end, { expr = true })

-- Oil
keymap.set("n", "-", "<cmd>Oil<CR>")

-- Moving lines around
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '>-2<CR>gv=gv")

-- Better moving
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- copy with out lose the pasted
keymap.set("x", "<leader>p", '"_dP')

-- Better clipboard interaction
keymap.set("n", "<leader>y", '"+y')
keymap.set("v", "<leader>y", '"+y')
keymap.set("n", "<leader>Y", '"+Y')

keymap.set("n", "<leader>bp", '"+p')
keymap.set("v", "<leader>bp", '"+p')
keymap.set("n", "<leader>bP", '"+P')

-- keymap.set("n", "<leader>d", "\"_d")
-- keymap.set("v", "<leader>d", "\"_d")

-- Linting
-- keymap.set("n", "<leader>gl", function() -- Create a custom key mapping
-- 	require("lint").try_lint() -- Trigger linting for the current file
-- end, { desc = "Trigger linting for current file" })

-- Tmux new session
keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ts<CR>")

-- Advanced replace search
keymap.set(
	"n",
	"<leader>S",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Advanced replace search" }
)

keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "toggle maximize tab" }) -- toggle maximize tab

-- Tab management
-- keymap.set("n", "<leader>to", ":tabnew<CR>")   -- open a new tab
-- keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close a tab
-- keymap.set("n", "<leader>tn", ":tabn<CR>")     -- next tab
-- keymap.set("n", "<leader>tp", ":tabp<CR>")     -- previous tab

-- Vim fugitive
-- keymap.set("n", "<leader>gG", vim.cmd.Git, { desc = "Vim fugitive" })

-- Git-blame
keymap.set("n", "<leader>gb", function()
	Snacks.git.blame_line()
end, { desc = "Git: toggle blame" })

-- Diff keymaps
keymap.set("n", "<leader>cc", ":diffput<CR>", { desc = "put diff from current to other during diff" }) -- put diff from current to other during diff
keymap.set("n", "<leader>cj", ":diffget 1<CR>", { desc = "get diff from left (local) during merge" }) -- get diff from left (local) during merge
keymap.set("n", "<leader>ck", ":diffget 3<CR>", { desc = "get diff from right (remote) during merge" }) -- get diff from right (remote) during merge
keymap.set("n", "<leader>cn", "]c", { desc = "Next diff hunk" }) -- next diff hunk
keymap.set("n", "<leader>cp", "[c", { desc = "Previous diff hunk" }) -- previous diff hunk

-- Git worktrees
keymap.set(
	"n",
	"<leader>gr",
	"<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
	{ silent = true, desc = "Show worktrees in Telescope" }
)
keymap.set(
	"n",
	"<leader>gR",
	"<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>",
	{ silent = true, desc = "Create worktrees in Telescope" }
)

-- Harpoon
keymap.set("n", "<leader>ha", require("harpoon.mark").add_file, { desc = "Add file to harpoon" })
keymap.set("n", "<leader>hh", require("harpoon.ui").toggle_quick_menu, { desc = "Marks UI menu" })
keymap.set("n", "<leader>ht", ":Telescope harpoon marks<CR>")
keymap.set("n", "<leader>h1", function()
	require("harpoon.ui").nav_file(1)
end, { desc = "Navigate to 1" })
keymap.set("n", "<leader>h2", function()
	require("harpoon.ui").nav_file(2)
end, { desc = "Navigate to 2" })
keymap.set("n", "<leader>h3", function()
	require("harpoon.ui").nav_file(3)
end, { desc = "Navigate to 3" })
keymap.set("n", "<leader>h4", function()
	require("harpoon.ui").nav_file(4)
end, { desc = "Navigate to 4" })

-- Undo Tree
keymap.set("n", "<leader>u", function()
	Snacks.picker.undo()
end, { desc = "Toggle undo tree" })

-- Vim REST Console
-- keymap.set("n", "<leader>xr", ":call VrcQuery()<CR>") -- Run REST query

-- Diagnostics
keymap.set("n", "<leader>ee", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "LSP: Show Line Diagnostics" })
keymap.set("n", "<leader>el", "<cmd>lua vim.diagnostic.setloclist()<CR>", { desc = "LSP: Set local diagnostic list" })
keymap.set(
	"n",
	"<leader>eq",
	"<cmd>lua vim.diagnostic.setqflist()<CR>",
	{ desc = "LSP: Local diagnostic list to quickfix list" }
)
-- keymap.set("n", "<leader>eh", "<cmd>lua vim.diagnostic.hide()<CR>", { desc = "LSP: Hide local diagnostic messages" })
-- keymap.set("n", "<leader>es", "<cmd>lua vim.diagnostic.show()<CR>", { desc = "LSP: Show local diagnostic messages" })
-- keymap.set("n", "<leader>el", function()
--     require("lint").try_lint()
-- end, { desc = "Trigger linting for current file" })
-- keymap.set("n", "<leader>en", "<cmd>lua vim.diagnostic.goto_next()<CR>", { desc = "LSP: Go to Next Diagnostic" })
-- keymap.set("n", "<leader>ep", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { desc = "LSP: Go to Previous Diagnostic" })

-- Formatting
keymap.set({ "n", "v" }, "<leader>lf", function()
	require("conform").format({
		lsp_fallback = true,
		async = true,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- Trouble
keymap.set("n", "<leader>ss", "<CMD>Trouble symbols toggle focus=true<CR>", { desc = "Symbols (Trouble)" })

-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", { desc = "Set breakpoint" })
keymap.set(
	"n",
	"<leader>bc",
	"<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>",
	{ desc = "Set conditional breakpoint" }
)
keymap.set(
	"n",
	"<leader>bl",
	"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
	{ desc = "Set message logger" }
)
keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>", { desc = "Clear all breakpoints" })
keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>", { desc = "List in Telescope all breakpoints" })
-- keymap.set("n", "<leader>ba", function()
-- 	Snacks.picker
-- end, { desc = "List in Telescope all breakpoints" })

-- Debugging starting with d
keymap.set(
	"n",
	"<leader>dc",
	"<cmd>lua require'dap'.continue()<cr>",
	{ desc = "Start Debugging or continues execution until the next breakpoint or end of program" }
)
keymap.set("n", "<leader>dd", function()
	require("dap").disconnect()
	require("dapui").close()
end, { desc = "Disconnects the debugger and closes the DAP UI" })
keymap.set("n", "<leader>de", function()
	require("telescope.builtin").diagnostics({ default_text = ":E:" })
end, { desc = "Shows diagnostics (errors) using Telescope with a default filter for ':E:'" })
keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>", { desc = "Lists stack frames using Telescope" })
keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>", { desc = "Lists DAP commands using Telescope" })
keymap.set("n", "<leader>di", function()
	require("dap.ui.widgets").hover()
end, { desc = "Shows the value of the variable under the cursor" })
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>", { desc = "Steps over" })
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>", { desc = "Steps into" })
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", { desc = "Re-runs the last debug configuration" })
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>", { desc = "Steps out" })
keymap.set(
	"n",
	"<leader>dr",
	"<cmd>lua require'dap'.repl.toggle()<cr>",
	{ desc = "Toggles the REPL (Read-Eval-Print Loop) interface" }
)
keymap.set("n", "<leader>dt", function()
	require("dap").terminate()
	require("dapui").close()
end, { desc = "Terminates the debugging session and closes the DAP UI" })
keymap.set("n", "<leader>du", "<cmd>lua require('dapui').toggle()<cr>", { desc = "Toggle DAP UI" })
keymap.set("n", "<leader>dU", "<cmd>lua require('dapui').open({reset = true})<cr>", { desc = "Rest DAP UI panes" })
keymap.set("n", "<leader>d?", function()
	local widgets = require("dap.ui.widgets")
	widgets.centered_float(widgets.scopes)
end, { desc = "Displays variable scopes in a centered floating window" })

-- ChatGPT

keymap.set({ "n", "v" }, "<leader>ac", "<cmd>ChatGPT<CR>", { desc = "ChatGPT", noremap = true, silent = true })
keymap.set(
	{ "n", "v" },
	"<leader>ae",
	"<cmd>ChatGPTEditWithInstruction<CR>",
	{ desc = "Edit with instruction", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>ag",
	"<cmd>ChatGPTRun grammar_correction<CR>",
	{ desc = "Grammar Correction", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>at",
	"<cmd>ChatGPTRun translate<CR>",
	{ desc = "Translate", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>ak",
	"<cmd>ChatGPTRun keywords<CR>",
	{ desc = "Keywords", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>ad",
	"<cmd>ChatGPTRun docstring<CR>",
	{ desc = "Docstring", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>aa",
	"<cmd>ChatGPTRun add_tests<CR>",
	{ desc = "Add Tests", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>ao",
	"<cmd>ChatGPTRun optimize_code<CR>",
	{ desc = "Optimize Code", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>as",
	"<cmd>ChatGPTRun summarize<CR>",
	{ desc = "Summarize", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>af",
	"<cmd>ChatGPTRun fix_bugs<CR>",
	{ desc = "Fix Bugs", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>ax",
	"<cmd>ChatGPTRun explain_code<CR>",
	{ desc = "Explain Code", noremap = true, silent = true }
)
keymap.set(
	{ "n", "v" },
	"<leader>al",
	"<cmd>ChatGPTRun code_readability_analysis<CR>",
	{ desc = "Code Readability Analysis", noremap = true, silent = true }
)
