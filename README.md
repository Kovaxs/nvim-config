# Neovim Config Improvement TODOs

This file tracks practical next tasks for the current `vim.pack`-based setup.

## TODOs

### In Progress

- [ ] Design `vim.pack` lazy-load strategy (per-plugin triggers via keymaps/commands/autocmds) and apply after current plugin split is stable.
- [ ] Add keymaps for deleting and updating plugins via `vim.pack`.
- [ ] Simplify format/lint trigger flow where pattern lists are long or repetitive.

### Debug (DAP) UX

- [ ] Add full `which-key` labels for common `<leader>d` mappings (not only the group).
- [ ] Add `nvim-dap` helpers: run to cursor, clear breakpoints, evaluate expression prompt.
- [ ] Add language-specific `dap.configurations` for frequent stacks (Python, TS/JS, Go).
- [ ] Verify Python debug workflow with `uv` + `debugpy` in real projects (pytest + script entrypoints).

### Terminal Workflow

- [ ] Add `<leader>oT` for a fresh ephemeral terminal while `<leader>ot` remains persistent.
- [ ] Add command history for terminal runner (`<leader>oe` / `<leader>or`).
- [ ] Add optional "send command without focusing terminal" behavior.
- [ ] Consider default terminal size/position options (bottom height preset, optional right split).

### Keymaps and Discoverability

- [ ] Reserve and document leader prefixes (`d`, `h`, `o`, `f`, `t`, etc.) to avoid collisions.
- [ ] Move plugin-specific keymaps into plugin modules where possible.
- [ ] Audit duplicate/overlapping mappings and unify naming in `desc` strings.

### Quality Checks / Tooling

- [ ] Add one local "pre-flight" command/script to run smoke + format + lint checks.
- [ ] Add a minimal check script for headless startup and LSP health.
- [ ] Keep formatter/linter tool lists aligned with `mason-tool-installer`.

### Testing Foundation

- [ ] Create `nvim/tests/` skeleton with minimal Plenary test harness.
- [ ] Add one or two initial tests for pure Lua helper behavior.
- [ ] Document single-file and filtered test commands once tests exist.

### Documentation

- [x] Refresh `AGENTS.md` to match current repo architecture and workflows.
- [ ] Add a short keymap reference section in README for new terminal/debug/harpoon mappings.
- [ ] Document plugin management conventions used by `nvim/lua/config/pack.lua`.

## Guides

### How to Add a New Language (Example: C++)

This config supports two ways of adding tools:

1. **Declarative (Recommended):** Code-as-truth; ensures tools install automatically on new machines.
2. **Manual (via UI):** Good for testing tools temporarily.

Here is how you add full support for C++ (`cpp`) across the stack:

### 1. Syntax Highlighting (Treesitter)

- **Declarative:** Open `nvim/lua/config/plugins/treesitter.lua` and add `"cpp"` to the `ensure_installed` table. Next time Nvim starts, it runs `:TSUpdateSync`.
- **Manual UI:** Run `:TSInstall cpp` in the command line.

### 2. Language Server (LSP)

- **Declarative:**
  1. Open `nvim/lua/config/plugins/mason_lspconfig.lua` and add `"clangd"` to `ensure_installed`.
  2. Open `nvim/lua/config/plugins/lspconfig.lua` and add `vim.lsp.config("clangd", {})` to `setup_servers()`, plus `"clangd"` to the `to_enable` list.
- **Manual UI:** Type `:Mason`, search for `clangd`, and press `i` to install. (You still need to add it to `lspconfig.lua`'s `to_enable` list to attach it to buffers).

### 3. Formatting

- **Declarative:**
  1. Open `nvim/lua/config/plugins/mason_tools.lua` and add `"clang-format"` to `ensure_installed`.
  2. Open `nvim/lua/config/plugins/conform.lua` and add `cpp = { "clang_format" }` to `formatters_by_ft`.
- **Manual UI:** Type `:Mason`, install `clang-format`. Update `conform.lua` so the editor knows to use it.

### 4. Linting

- **Declarative:**
  1. Open `nvim/lua/config/plugins/mason_tools.lua` and add `"cpplint"` to `ensure_installed`.
  2. Open `nvim/lua/config/plugins/nvim_lint.lua` and add `cpp = { "cpplint" }` to `lint.linters_by_ft`.
- **Manual UI:** Type `:Mason`, install `cpplint`. Update `nvim_lint.lua` to run it on buffer changes.

### 5. Autocompletion & Snippets

- **Zero Config Needed:** Because we use `blink.cmp` and `friendly-snippets`, autocompletions automatically pull from `clangd` as soon as the LSP attaches. Standard C++ snippets will also appear in the completion menu natively.
