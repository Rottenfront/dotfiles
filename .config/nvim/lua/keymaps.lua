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

keymap("n", "<leader>bv", "<cmd>vsplit<cr>", opts)
keymap("n", "<leader>bs", "<cmd>split<cr>", opts)

keymap("n", "<leader>bh", "<C-w>h", opts)
keymap("n", "<leader>bj", "<C-w>j", opts)
keymap("n", "<leader>bk", "<C-w>k", opts)
keymap("n", "<leader>bl", "<C-w>l", opts)

-- Telescope keymaps
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts)
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)
keymap("n", "<leader>fc", "<cmd>Telescope commands<cr>", opts)

-- LSP keymaps
keymap("n", "<leader>ld", vim.lsp.buf.definition, opts)
keymap("n", "<leader>lD", vim.lsp.buf.declaration, opts)
keymap("n", "<leader>li", vim.lsp.buf.implementation, opts)
keymap("n", "<leader>lr", vim.lsp.buf.references, opts)
keymap("n", "<leader>ln", vim.lsp.buf.rename, opts)
keymap("n", "<leader>la", vim.lsp.buf.code_action, opts)
keymap("n", "<leader>lf", vim.lsp.buf.format, opts)
keymap("n", "<leader>lh", vim.lsp.buf.hover, opts)
keymap("n", "<leader>ls", vim.lsp.buf.signature_help, opts)

-- Diagnostics
keymap("n", "[d", vim.diagnostic.goto_prev, opts)
keymap("n", "]d", vim.diagnostic.goto_next, opts)
keymap("n", "<leader>ld", vim.diagnostic.open_float, opts)

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
