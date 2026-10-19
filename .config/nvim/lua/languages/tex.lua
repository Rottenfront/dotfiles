local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    gh('lervag/vimtex'),
})

vim.g.tex_flavor = 'latex'

vim.g.vimtex_view_method = 'zathura'

vim.g.vimtex_quickfix_mode = 2
vim.g.vimtex_quickfix_open_on_warning = 0

vim.g.vimtex_quickfix_ignore_filters = {
    'Underfull \\hbox',
    'Overfull \\hbox',
    'LaTeX Font Warning',
}

vim.g.vimtex_compiler_method = 'latexmk'

vim.g.vimtex_compiler_latexmk = {
    build_dir = '',
    callback = 1,
    continuous = 1,
    executable = 'latexmk',
    hooks = {},
    options = {
        '-lualatex',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode'
    }
}

vim.lsp.config('texlab', {
    cmd = { 'texlab' },
    latexFormatter = 'tex-fmt',
    on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }

        vim.keymap.set("n", "<leader>lb", "<cmd>TexlabBuild<CR>",
            vim.tbl_extend("force", opts, {
                desc = "LaTeX: Build",
            }))

        vim.keymap.set("n", "<leader>lc", "<cmd>TexlabCancelBuild<CR>",
            vim.tbl_extend("force", opts, {
                desc = "LaTeX: Cancel build",
            }))
    end,
})

vim.lsp.enable('texlab')
