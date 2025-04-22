return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")
            configs.setup({
                ensure_installed = { "query", "lua", "python", "latex", "markdown", "markdown_inline", "dockerfile",
                    "bibtex", "json", "yaml", "html", "css", "markdown", "markdown_inline", "bash", "lua", "vim",
                    "dockerfile", "gitignore", "vimdoc", "c", "nix", "regex"
                },
                auto_install = true,
                ignore_install = {},
                modules = {},
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>", -- set to `false` to disable one of the mappings
                        node_incremental = "<CR>",
                        scope_incremental = false,
                        node_decremental = "<BS>",
                    },
                },
            })
        end,
    }
}
