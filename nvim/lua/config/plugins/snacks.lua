return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        explorer = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        picker = {
            enabled = true,
            matcher = {
                frecency = true,
            },
        },
        lazygit = {
            -- theme = {
            --     selectedLineBgColor = { bg = "CursorLine" },
            -- },
            win = {
                -- -- The first option was to use the "dashboard" style, which uses a
                -- -- 0 height and width, see the styles documentation
                -- -- https://github.com/folke/snacks.nvim/blob/main/docs/styles.md
                -- style = "dashboard",
                -- But I can also explicitly set them, which also works, what the best
                -- way is? Who knows, but it works
                width = 0,
                height = 0,
            },
        },
        git = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        scope = { enabled = true },
        scroll = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
    },
}
