-- General purpose linters
return {
    -- https://github.com/mfussenegger/nvim-lint
    'mfussenegger/nvim-lint',
    event = {
        'BufWritePost',
        'BufNewFile',
        'BufReadPre'
    },
    -- event = 'Lazy',
    config = function()
        -- Define a table of linters for each filetype (not extension).
        -- Additional linters can be found here: https://github.com/mfussenegger/nvim-lint#available-linters
        local lint = require("lint") -- Load the lint module
        lint.linters_by_ft = {
            python = {
                -- Uncomment whichever linters you prefer
                -- 'flake8',
                -- 'mypy',
                -- 'pylint',
                'ruff',
            },
            lua = {
                'luacheck',
            }
        }
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })   -- Create an autocommand group

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, { -- Set up autocommands
            group = lint_augroup,
            callback = function()
                lint.try_lint() -- Call the linting function
            end,
        })

        -- Automatically run linters after saving.  Use "InsertLeave" for more aggressive linting.
        -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        --     -- Only run linter for the following extensions. Remove this to always run.
        --     -- pattern = { "*.py", },
        --     callback = function()
        --         require("lint").try_lint()
        --     end,
        -- })
    end
}
