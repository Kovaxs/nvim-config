-- Code Tree Support / Syntax Highlighting
return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
        "windwp/nvim-ts-autotag",
    },
    config = function()
        -- import nvim-treesitter plugin
        local treesitter = require("nvim-treesitter.configs")

        -- configure treesitter
        treesitter.setup({ -- enable syntax highlighting
            highlight = {
                enable = true,
            },
            -- enable indentation
            indent = { enable = true },
            -- enable autotagging (w/ nvim-ts-autotag plugin)
            autotag = {
                enable = true,
            },
            -- ensure these language parsers are installed
            ensure_installed = {
                "lua",
                "python",
                "latex",
                "markdown",
                "markdown_inline",
                "dockerfile",
                "bibtex",
                "json",
                "yaml",
                "html",
                "css",
                "markdown",
                "markdown_inline",
                "bash",
                "lua",
                "vim",
                "dockerfile",
                "gitignore",
                "vimdoc",
                "c",
                "nix",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<leader>n",
                    node_incremental = "<leader>n",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        })
    end,
}
