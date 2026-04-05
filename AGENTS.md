# AGENTS.md
Operational guide for coding agents working in this repository.

## Repository Scope
- Root repo contains helper scripts (`install.sh`, `setup.sh`) and Neovim config in `nvim/`.
- Main code is Lua-based Neovim configuration.
- Plugin management uses Neovim 0.12 built-in `vim.pack`.
- There is no formal CI pipeline or committed test suite.

## Local Rules Discovery (Highest Priority)
- Cursor rules:
  - `.cursorrules`: not present
  - `.cursor/rules/`: not present
- Copilot instructions:
  - `.github/copilot-instructions.md`: not present
- If any of these files are added later, follow them before this document.

## Working Directory
- Use `nvim/` for configuration/code changes.
- Use repository root for docs and scripts.
- Do not move the Neovim config out of `nvim/`.

## Codebase Layout
- `nvim/init.lua`: global options and bootstrap.
- `nvim/lua/config/pack.lua`: plugin registration/load flow.
- `nvim/lua/config/plugins/*.lua`: one plugin module per file.
- `nvim/lua/core/keymaps.lua`: global keymaps and terminal helpers.
- `nvim/lua/core/autocmds.lua`: shared autocmds.
- `nvim/lua/ui/statusline.lua`: statusline setup.
- `nvim/LuaSnip/all.lua`: snippet definitions.

## Setup Commands
- Link config into default Neovim location: `./setup.sh`
- Install pinned Neovim helper version: `./install.sh`
- Verify Neovim is installed: `nvim --version`

## Build / Smoke Commands
No compile/build artifact step exists. Use smoke checks:
- Startup smoke test: `nvim --headless "+qa"`
- Full health check: `nvim --headless "+checkhealth" "+qa"`
- LSP health check: `nvim --headless "+checkhealth vim.lsp" "+qa"`
- Plugin updates (networked): `nvim --headless "+PackUpdate" "+qa"`

## Lint / Format Commands
- Format all Lua: `stylua nvim/**/*.lua`
- Check Lua formatting: `stylua --check nvim/**/*.lua`
- Lint all Lua: `luacheck nvim`
- Lint one file: `luacheck nvim/lua/config/plugins/dap.lua`
- Format one file: `stylua nvim/lua/config/plugins/dap.lua`

Relevant config files:
- `nvim/lua/config/plugins/conform.lua`
- `nvim/lua/config/plugins/nvim_lint.lua`
- `.luacheckrc`
- `.luarc.json`

## Test Commands (Including Single-Test Guidance)
Current state:
- No `nvim/tests/` directory exists yet.
- Treat startup and health checks as practical tests.

Current practical checks:
- `nvim --headless "+qa"`
- `nvim --headless "+checkhealth vim.lsp" "+qa"`

If tests are introduced, prefer Plenary Busted:
- Run all tests:
  - `nvim --headless -c "PlenaryBustedDirectory nvim/tests { minimal_init = 'nvim/tests/minimal_init.lua' }" -c qa`
- Run a single test file:
  - `nvim --headless -c "PlenaryBustedFile nvim/tests/path/to/file_spec.lua" -c qa`
- Run a single test by filter:
  - `nvim --headless -c "PlenaryBustedFile nvim/tests/path/to/file_spec.lua { filter = 'case name' }" -c qa`

## Plugin Module Conventions
- Add plugin modules under `nvim/lua/config/plugins/<name>.lua`.
- Register each module in `nvim/lua/config/pack.lua`.
- Use module contract:
  - `M.spec` for plugin source/options
  - `M.pre_setup()` optional
  - `M.setup()` optional
- Guard optional dependencies with `pcall(require, ...)`.

## Lua Style Guidelines
Follow local style in touched files and keep edits minimal.

### Formatting
- Keep Stylua-compatible formatting.
- Preserve existing indentation style (tabs/spaces) in each file.
- Keep trailing commas in multiline tables.
- Do not reformat unrelated lines.

### Imports and Requires
- Use local `require` bindings when reused.
- Inline `require("module")` for one-off usage is acceptable.
- Keep require paths explicit and stable.

### Types and Annotations
- Use EmmyLua annotations when they improve clarity:
  - `---@param`, `---@return`, `---@type`, `---@class`
- Add annotations for non-obvious callbacks/tables.

### Naming
- Local variables/functions: `snake_case`.
- Module file names: lowercase with underscores where needed.
- Keymap descriptions (`desc`): concise and action-first.

### Keymaps
- Use `vim.keymap.set` only.
- Always include `desc`.
- Prefer buffer-local mappings for buffer/LSP scope.
- Check existing `<leader>` mappings before adding new ones.

### Error Handling
- Use `pcall` around optional integrations.
- Use `vim.notify(..., vim.log.levels.WARN/ERROR)` for recoverable issues.
- Use hard `error(...)` only when startup must stop.

### Diagnostics / LSP
- Keep diagnostics behavior centralized in `nvim/lua/config/plugins/lspconfig.lua`.
- Prefer `vim.diagnostic.config(...)` over scattered overrides.
- Keep float border/diagnostic UX consistent across modules.

### Autocmds
- Use explicit augroups via `vim.api.nvim_create_augroup`.
- Prefer `vim.opt_local` for buffer/window-local behavior.
- Keep callbacks short and deterministic.

### Comments and Docs
- Add comments only for non-obvious intent.
- Update docs when workflow or commands change.

## Change Management
- Make focused, minimal edits.
- Avoid touching unrelated files/formatting.
- Do not remove user behavior unless explicitly requested.
- Update `AGENTS.md` when build/lint/test workflow changes.

## Quick Pre-PR Checklist
- Lint/format checks run for touched files.
- `nvim --headless "+qa"` succeeds.
- `nvim --headless "+checkhealth vim.lsp" "+qa"` reviewed when LSP changed.
- Relevant docs updated (`AGENTS.md`, `README.md`).
