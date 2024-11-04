return {
  "lervag/vimtex",
  lazy = false, -- lazy-loading will disable inverse search
  config = function()
    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = vim.api.nvim_create_augroup("lazyvim_vimtex_conceal", { clear = true }),
      pattern = { "bib", "tex" },
      callback = function()
        vim.wo.conceallevel = 2
      end,
    })

    vim.g.vimtex_mappings_disable = { ["n"] = { "K" } } -- disable `K` as it conflicts with LSP hover
    vim.g.vimtex_quickfix_method = vim.fn.executable("pplatex") == 1 and "pplatex" or "latexlog"

    -- Set Zathura as the default PDF viewer for VimTeX
    vim.g.vimtex_view_method = 'sioyek'
    -- vim.g.vimtex_view_method = 'general'
    -- vim.g.vimtex_view_general_viewer = 'open' -- Use 'open' for macOS
    -- vim.g.vimtex_view_general_options = ''
    -- vim.g.vimtex_view_method = 'general'
    -- vim.g.vimtex_view_general_viewer = 'open'
    -- vim.g.vimtex_view_general_options = '@pdf'
  end,
}
