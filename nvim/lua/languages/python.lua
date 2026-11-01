vim.lsp.config('pyright', {
    cmd = { 'pyright' },
    settings = {
        ['pyright'] = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "standard",
            },
        },
    },
})

vim.lsp.enable('pyright')
