---@brief
---
--- TypeScript language server (typescript-language-server).
---
--- Install with npm:
--- ```sh
--- npm i -g typescript typescript-language-server
--- ```
return {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'javascript',
        'javascriptreact',
        'javascript.jsx',
        'typescript',
        'typescriptreact',
        'typescript.tsx',
    },
    root_markers = {
        'tsconfig.json',
        'jsconfig.json',
        'package.json',
        '.git',
    },
}
