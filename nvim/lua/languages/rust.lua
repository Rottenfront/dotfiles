vim.lsp.config('rust_analyzer', {
    cmd = { 'rust-analyzer' },
    settings = {
        ["rust-analyzer"] = {
            assist = {
                importGranularity = "module",
                importPrefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
})

vim.lsp.enable('rust_analyzer')
