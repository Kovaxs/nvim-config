-- minimal_init.lua
-- vim.cmd('set nocompatible')
-- vim.cmd('filetype plugin on')
-- vim.cmd('syntax on')

-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This has to be set before initializing lazy
vim.g.mapleader = " "

vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75", })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B", })
vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF", })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66", })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379", })
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD", })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2", })
-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
  change_detection = {
    enebled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugging changes are made
  },
})
-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")

