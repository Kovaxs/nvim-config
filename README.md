# Neovim Config Improvement TODOs

This file tracks improvements identified and worked on during this session.

## Still To Improve

- [ ] Design `vim.pack` lazy-load strategy (per-plugin triggers via keymaps/commands/autocmds) and apply after current plugin split is stable.
- [ ] Add keymaps for deleting and updating plugins via `vim.pack`.
- [ ] Simplify `BufWritePre` format target selection by replacing the long file-extension pattern list with a cleaner strategy.
