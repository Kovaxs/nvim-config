print("advent of neovim")

require("config.lazy")

-- time managers
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0

-- Session Management
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.cmdheight = 1 -- or any number you prefer

-- Spell check
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.g.spellfile_URL = "https://ftp.nluug.nl/vim/runtime/spell/"

-- Identation
vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })

-- Line Number
vim.opt.relativenumber = true
vim.opt.number = true

-- vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.relativenumber = true
-- Tabs & Identation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.softtabstop = 4

-- Line Wrapping
vim.opt.wrap = false

-- Search Settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Cursor Line
vim.opt.cursorline = true
-- opt.guicursor = ""
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.diagnostic.config({
    float = { border = "rounded" }, -- add border to diagnostic popups
})

-- Performance
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- Backspace
vim.opt.backspace = "indent,eol,start"

-- Clipboard
-- opt.clipboard:append("unnamedplus")

-- Split Windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Consider - as part of keyword
-- opt.iskeyword:append("-")
-- opt.iskeyword:append("_")

-- Remove underscore from `iskeyword` for all file types
-- opt.iskeyword:remove("_")

-- Disable the mouse while in nvim
-- vim.opt.mouse = ""

-- Folding
vim.opt.foldlevel = 20
-- disable folding on startup
vim.opt.foldenable = false
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Utilize Treesitter folds
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--     callback = function()
--         -- check if treesitter has parser
--         if require("nvim-treesitter.parsers").has_parser() then
--             -- use treesitter folding
--             vim.opt.foldmethod = "expr"
--             vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--         else
--             -- use alternative foldmethod
--             vim.opt.foldmethod = "syntax"
--         end
--     end,
-- })
-- Scrolling
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

-- Misc
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "89"


-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", { clear = true }),
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
    end,
})

local job_id = 0
vim.keymap.set("n", "<space>to", function()
    vim.cmd.vnew()
    vim.cmd.term()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 5)

    job_id = vim.bo.channel
end, { desc = "Terminal: toggle terminal" })

local current_command = ""
vim.keymap.set("n", "<space>te", function()
    current_command = vim.fn.input("Command: ")
end, { desc = "Terminal: save command to run in terminal" })

vim.keymap.set("n", "<space>tr", function()
    if current_command == "" then
        current_command = vim.fn.input("Command: ")
    end

    vim.fn.chansend(job_id, { current_command .. "\r\n" })
end, { desc = "Terminal: run a save command or write command to run" })

require("core.keymaps")
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/LuaSnip/" })

-- MINI
require("mini.surround").setup()
require("mini.pairs").setup()
