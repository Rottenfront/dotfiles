--[[
 THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT
 `lvim` is the global options object
]]

-- vim options
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
    enabled = true,
    timeout = 1000,
}
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings <https://www.lunarvim.org/docs/configuration/keybindings>
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- -- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["W"] = { "<cmd>noautocmd w<cr>", "Save without formatting" }
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

lvim.plugins = {
    { "p00f/nvim-ts-rainbow" },
    { "yonlu/omni.vim" },
    {
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
        config = function()
            vim.defer_fn(function()
                require("copilot").setup {
                    panel = {
                        enabled = true,
                        auto_refresh = false,
                        keymap = {
                            jump_prev = "[[",
                            jump_next = "]]",
                            accept = "<CR>",
                            refresh = "gr",
                            open = "<M-CR>"
                        },
                        layout = {
                            position = "bottom", -- | top | left | right
                            ratio = 0.4
                        },
                    },
                    suggestion = {
                        enabled = true,
                        auto_trigger = false,
                        debounce = 75,
                        keymap = {
                            accept = "<M-l>",
                            accept_word = false,
                            accept_line = false,
                            next = "<M-]>",
                            prev = "<M-[>",
                            dismiss = "<C-]>",
                        },
                    },
                    filetypes = {},
                    copilot_node_command = 'node', -- Node.js version must be > 16.x
                    server_opts_overrides = {},
                }
            end, 100)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        after = { "copilot.lua", "nvim-cmp" },
    },
}

lvim.colorscheme = "lunar"

lvim.builtin.cmp.formatting.source_names["copilot"] = "(Copilot)"
table.insert(lvim.builtin.cmp.sources, 1, { name = "copilot" })

lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

-- Automatically install missing parsers when entering buffer
lvim.builtin.treesitter.auto_install = true
lvim.builtin.treesitter.rainbow.enable = true

-- lvim.builtin.treesitter.ignore_install = { "haskell" }

-- -- generic LSP settings <https://www.lunarvim.org/docs/languages#lsp-support>

-- --- disable automatic installation of servers
-- lvim.lsp.installer.setup.automatic_installation = false

-- ---configure a server manually. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---see the full default list `:lua =lvim.lsp.automatic_configuration.skipped_servers`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. IMPORTANT: Requires `:LvimCacheReset` to take effect
-- ---`:LvimInfo` lists which server(s) are skipped for the current filetype
-- lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- linters and formatters <https://www.lunarvim.org/docs/languages#lintingformatting>
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "stylua" },
--   {
--     command = "prettier",
--     extra_args = { "--print-width", "100" },
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     command = "shellcheck",
--     args = { "--severity", "warning" },
--   },
-- }

-- -- Additional Plugins <https://www.lunarvim.org/docs/plugins#user-plugins>
-- lvim.plugins = {
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
-- }

-- -- Autocommands (`:help autocmd`) <https://neovim.io/doc/user/autocmd.html>
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

require("packer").init({
    autoremove = true,
})
require("packer").startup(function(use)
    -- Packer can manage itself
    use("wbthomason/packer.nvim")
    -- Collection of common configurations for the Nvim LSP client
    use("neovim/nvim-lspconfig")
    -- Visualize lsp progress
    use({
        "j-hui/fidget.nvim",
        config = function()
            require("fidget").setup()
        end
    })

    -- Autocompletion framework
    use("hrsh7th/nvim-cmp")
    use({
        -- cmp LSP completion
        "hrsh7th/cmp-nvim-lsp",
        -- cmp Snippet completion
        "hrsh7th/cmp-vsnip",
        -- cmp Path completion
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        after = { "hrsh7th/nvim-cmp" },
        requires = { "hrsh7th/nvim-cmp" },
    })
    -- See hrsh7th other plugins for more great completion sources!
    -- Snippet engine
    use('hrsh7th/vim-vsnip')
    -- Adds extra functionality over rust analyzer
    use("simrat39/rust-tools.nvim")

    -- Optional
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")
    use("nvim-telescope/telescope.nvim")

    -- Some color scheme other then default
    use("arcticicestudio/nord-vim")
end)

-- the first run will install packer and our plugins
if packer_bootstrap then
    require("packer").sync()
    return
end

vim.cmd([[ colorscheme nord ]])

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local function on_attach(client, buffer)
    local keymap_opts = { buffer = buffer }
    -- Code navigation and shortcuts
    vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
    vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
    vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set("n", "ga", vim.lsp.buf.code_action, keymap_opts)

    -- Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            vim.diagnostic.open_float(nil, { focusable = false })
        end,
        group = diag_float_grp,
    })

    -- Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
end

-- Configure LSP through rust-tools.nvim plugin.
-- rust-tools will configure and enable certain LSP features for us.
-- See https://github.com/simrat39/rust-tools.nvim#configuration
local opts = {
    tools = {
        runnables = {
            use_telescope = true,
        },
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
}

require("rust-tools").setup(opts)

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        -- Add tab support
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }),
    },

    -- Installed sources
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "path" },
        { name = "buffer" },
    },
})

-- have a fixed column for the diagnostics to appear in
-- this removes the jitter when warnings/errors flow in
vim.wo.signcolumn = "yes"

-- " Set updatetime for CursorHold
-- " 300ms of no cursor movement to trigger CursorHold
-- set updatetime=300
vim.opt.updatetime = 100
