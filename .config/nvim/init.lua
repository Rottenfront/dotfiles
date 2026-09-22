if vim.g.neovide then
    vim.g.neovide_opacity = 0.9
    vim.o.guifont = "Cascadia Code:h10"
end

require('util')
require('lsp')
require('git')

require('keymaps')

-- ============================================================================
-- Basic Configuration
-- ============================================================================
local opt = vim.opt

-- Editor settings
opt.number = true
opt.relativenumber = true
opt.linebreak = true
opt.termguicolors = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.completeopt = "menu,menuone,noselect"
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.mouse = "a"
opt.undofile = true
opt.undodir = vim.fn.expand("~/.config/nvim/undo")

-- Indentation
local autocmd = vim.api.nvim_create_autocmd
opt.expandtab = true
opt.shiftwidth = 4
opt.softtabstop = 4
opt.tabstop = 4

autocmd("FileType", {
    pattern = { "haskell", "ocaml", "nix" },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.tabstop = 2
    end
});

-- ============================================================================
-- Autocmd Configuration
-- ============================================================================
local augroup = vim.api.nvim_create_augroup

-- Create undo directory if it doesn't exist
augroup("UndoDir", { clear = true })
autocmd("BufWritePre", {
    group = "UndoDir",
    callback = function()
        local undodir = vim.fn.expand("~/.config/nvim/undo")
        if vim.fn.isdirectory(undodir) == 0 then
            vim.fn.mkdir(undodir, "p")
        end
    end,
})

-- Highlight on yank
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 100,
        })
    end,
})
