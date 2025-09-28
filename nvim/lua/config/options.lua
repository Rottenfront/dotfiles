-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

if vim.g.neovide then
  vim.o.guifont = "Cascadia Code:h12"
end

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.g.lazyvim_check_order = false
vim.opt.ignorecase = false
vim.opt.smartcase = false
vim.opt.wrap = true

vim.opt.linebreak = true
vim.opt.breakindent = true
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ocaml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

vim.cmd([[
  set wrap
]])
