---@brief
---
--- Astro language server.
---
--- Install with npm:
--- ```sh
--- npm i -g @astrojs/language-server
--- ```
return {
    cmd = { 'astro-ls', '--stdio' },
    filetypes = { 'astro' },
    init_options = {
        typescript = {},
    },
    root_markers = {
        'astro.config.mjs',
        'astro.config.ts',
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        '.git',
    },
    before_init = function(_, config)
        config.init_options = config.init_options or {}
        config.init_options.typescript = config.init_options.typescript or {}

        local function has_tsserver(lib_dir)
            return vim.uv.fs_stat(lib_dir .. '/tsserverlibrary.js')
                or vim.uv.fs_stat(lib_dir .. '/typescript.js')
                or vim.uv.fs_stat(lib_dir .. '/tsserver.js')
        end

        local tsdk = config.init_options.typescript.tsdk
        if not tsdk and config.root_dir then
            local local_tsdk = config.root_dir .. '/node_modules/typescript/lib'
            if has_tsserver(local_tsdk) then
                tsdk = local_tsdk
            end
        end

        if not tsdk then
            local mason_tsdk = vim.fn.expand('$MASON/packages/astro-language-server/node_modules/typescript/lib')
            if has_tsserver(mason_tsdk) then
                tsdk = mason_tsdk
            end
        end

        if tsdk then
            config.init_options.typescript.tsdk = tsdk
        end
    end,
}
