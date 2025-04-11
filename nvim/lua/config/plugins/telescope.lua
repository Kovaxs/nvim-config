return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            require('telescope').setup {
                pickers = {
                    find_files = {
                        theme = "ivy"
                    }
                },
                extensions = {
                    fzf = {}
                }
            }

            require('telescope').load_extension('fzf')

            vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
            vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)
            vim.keymap.set("n", "<leader>fm", function()
                require("telescope.builtin").treesitter({ default_text = ":method:" })
            end, {
                desc =
                "This custom function utilizes Telescope's treesitter provider and sets the default text to 'method:', likely used for finding and selecting methods within your code.",
            }) -- This custom function utilizes Telescope's treesitter provider and sets the default text to ":method:", likely used for finding and selecting methods within your code.
            vim.keymap.set("n", "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", { desc = "LSP: Go to Definition" })
            vim.keymap.set("n", "<leader>fr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP: Show References" })
            vim.keymap.set(
                "n",
                "<leader>fs",
                require("telescope.builtin").current_buffer_fuzzy_find,
                { desc = "Opens a Telescope prompt to search within the currently open buffer." }
            ) -- Opens a Telescope prompt to search within the currently open buffer.
            vim.keymap.set("n", "<leader>fa", function()
                require("telescope.builtin").find_files({ hidden = true }, { additional_args = { "-u" } })
            end, { desc = "Opens a Telescope prompt to search and open files on your system." }) -- Opens a Telescope prompt to search and open files on your system.
            vim.keymap.set("n", "<space>en", function()
                require('telescope.builtin').find_files {
                    cwd = vim.fn.stdpath("config")
                }
            end)
            vim.keymap.set("n", "<space>ep", function()
                require('telescope.builtin').find_files {
                    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
                }
            end)

            require "config.telescope.multigrep".setup()
        end
    }
}
