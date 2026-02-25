return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        local mason = require("mason")
        local mason_lspconfig = require("mason-lspconfig")
        local mason_tool_installer = require("mason-tool-installer")

        mason.setup({
            PATH = "append",
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        mason_lspconfig.setup({
            automatic_installation = true,
            ensure_installed = {
                "astro",
                "clangd",
                "lua_ls",
                "pyright",
                "ruff",
                "rust_analyzer",
                "ts_ls",
            },
        })

        mason_tool_installer.setup({
            ensure_installed = {
                "clang-format",
                "ruff",
                "rustfmt",
                "sql-formatter",
                "stylua",
            },
        })
    end,
}
