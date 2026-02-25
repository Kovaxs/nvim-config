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
    root_markers = {
        'astro.config.mjs',
        'astro.config.ts',
        'package.json',
        'tsconfig.json',
        'jsconfig.json',
        '.git',
    },
}
