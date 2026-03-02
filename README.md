# Neovim Config Improvement TODOs

This file tracks improvements identified and worked on during this session.

## Completed

- [ ] Fix Oil keymap conflict (`-` was being overridden by opencode mapping).
- [x] Fix LuaSnip runtime bug in `typescriptreact` `co` snippet (invalid `M.sn`/`M.t` and dynamic node wiring).
- [x] Baseline Neovim startup profiling with `--startuptime`.
- [ ] Remove eager plugin setup from `nvim/init.lua` and move setup into plugin specs.
- [ ] Add lazy/deferred loading for optional plugins (render-markdown, zen, twilight, fugitive, md-pdf, lualine, vimtex).
- [ ] Add lazy-loaded `mini` plugin specs (`mini.pairs`, `mini.surround`).
- [ ] Convert Telescope/refactoring/git-worktree loading flow to command/key based loading.
- [ ] Re-profile startup and confirm improvement.
- [ ] Fix interactive input lag regression (restore responsive timeout settings and remove scheduled LSP initialization).

## Still To Improve

- [ ] Audit and clean remaining legacy Telescope-only mappings in `nvim/lua/core/keymaps.lua`.
- [ ] Revisit startup-heavy plugins one-by-one with guarded profiling (focus: `snacks`, `treesitter`, `oil`).
- [ ] Decide whether `mason.nvim` should stay lazy-loaded or initialize eagerly to avoid background hitching.
- [ ] Review `lualine` config for correctness and simplification (double setup + custom theme consistency).
- [ ] Verify ftplugin/local-option scope behavior for filetype-specific settings.
- [ ] Remove stale/commented blocks in plugin specs to reduce config drift and confusion.

## Validation TODOs

- [ ] Run `nvim --headless "+qa"` after each startup-related change.
- [ ] Run `nvim --startuptime /tmp/nvim-startup.log --headless "+qa"` and compare before/after.
- [ ] Manually verify responsiveness in `opencode` and `lazygit` windows after each change.
