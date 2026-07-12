if vim.g.neovide then
    vim.g.neovide_opacity = 0.9
    vim.o.guifont = "Cascadia Code:h10"
end

require('util')
require('lsp')
require('git')


-- ============================================================================
-- Basic Configuration
-- ============================================================================
local opt = vim.opt

-- Editor settings
opt.number = true
opt.relativenumber = true
opt.wrap = true
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
    pattern = { "haskell", "ocaml" },
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.tabstop = 2
    end
});


-- ============================================================================
-- Keymaps
-- ============================================================================

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Telescope keymaps
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)

-- LSP keymaps
keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
keymap("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
keymap("n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format()<cr>", opts)
keymap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

-- Diagnostics
keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
keymap("n", "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)

-- DAP keymaps
keymap("n", "<leader>db", "<cmd>DapToggleBreakpoint<cr>", opts)
keymap("n", "<leader>dc", "<cmd>DapContinue<cr>", opts)
keymap("n", "<leader>do", "<cmd>DapStepOver<cr>", opts)
keymap("n", "<leader>di", "<cmd>DapStepInto<cr>", opts)
keymap("n", "<leader>dt", "<cmd>DapTerminate<cr>", opts)

-- Git keymaps
keymap("n", "<leader>gs", "<cmd>Git<cr>", opts)
keymap("n", "<leader>gd", "<cmd>Gvdiffsplit<cr>", opts)
keymap("n", "<leader>gl", "<cmd>Git log<cr>", opts)

-- File tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- Overseer
keymap("n", "<leader>om", "<cmd>OverseerToggle<cr>", opts)
keymap("n", "<leader>or", "<cmd>OverseerRun<cr>", opts)

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

