local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    gh('mrcjkb/haskell-tools.nvim'),
})

-- vim.lsp.config('hls', {
--     filetypes = { 'haskell', 'lhaskell', 'cabal' },
--     cmd = { "haskell-language-server-wrapper", "--lsp" },
--     settings = {
--         haskell = {
--             formattingProvider = "fourmolu",
--             checkProject = true,
--         }
--     },
--     on_attach = function(client, bufnr)
--         local opts = { buffer = bufnr, remap = false }
--         vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--         vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--         vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--         vim.keymap.set("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, opts)
--     end,
-- })
--
-- vim.lsp.enable('hls')
