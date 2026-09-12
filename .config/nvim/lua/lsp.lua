local gh = function(x) return 'https://github.com/' .. x end
local autocmd = vim.api.nvim_create_autocmd

local lspconfig = function(name, config)
    vim.lsp.config(name, config)
    vim.lsp.enable(name)
end

-----------------------------------------------------------
--- PLUGINS
-----------------------------------------------------------

vim.pack.add({
    gh('neovim/nvim-lspconfig'),

    gh('saghen/blink.lib'),
    gh('saghen/blink.cmp'),


    gh('nvim-treesitter/nvim-treesitter'),
    gh('nvim-treesitter/nvim-treesitter-textobjects'),

    {
        src = gh('mfussenegger/nvim-lint'),
        name = 'lint',
    },

    gh('stevearc/conform.nvim'),
})

-----------------------------------------------------------
--- LSP CONFIG
-----------------------------------------------------------

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
})

local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client.name == "qmlls" then
            local ns = vim.lsp.diagnostic.get_namespace(client.id)

            vim.diagnostic.config({
                virtual_text = false,
                signs = false,
                underline = false,
            }, ns)
        end
    end,
})


-----------------------------------------------------------
--- LSP SERVERS
-----------------------------------------------------------

lspconfig('rust_analyzer', {
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
lspconfig('clangd', {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
    },
})
lspconfig('pyright', {
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
lspconfig('hls', {
    cmd = { "haskell-language-server-wrapper", "--lsp" },

    filetypes = {
        "haskell",
        "lhaskell",
        "cabal",
    },

    root_markers = {
        "hie.yaml",
        "cabal.project",
        "*.cabal",
        "stack.yaml",
        ".git",
    },
})
lspconfig('jsonls', {
    cmd = { 'vscode-json-language-server', '--stdio' }
})
lspconfig('ocamllsp', {
    cmd = { 'ocamllsp' }
})
lspconfig('lua_ls', {
    cmd = { "lua-language-server" }
})
lspconfig('tinymist', {
    cmd = { "tinymist" }
})
lspconfig('qmlls', {
    cmd = { "qmlls6" },
    filetypes = { "qml" },
    single_file_support = true,
})


-----------------------------------------------------------
--- BLINK
-----------------------------------------------------------

local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup({
    keymap = {
        preset = "enter",
    },
    appearance = {
        use_nvim_cmp_as_default = false,
    },
    fuzzy = {
        implementation = 'rust',
        sorts = {
            'exact',
            'score',
            'sort_text'
        }
    },
    sources = {
        default = {
            "lsp",
            "path",
            "snippets",
            "buffer",
        },
        providers = {
            lsp = {
                name = "LSP",
                enabled = true,
            },
            path = {
                opts = {
                    get_cwd = function(_)
                        return vim.fn.getcwd()
                    end,
                },
            },
        },
    },
    completion = {
        menu = {
            enabled = true,
            max_height = 10,
            border = "rounded",
        },
        documentation = {
            auto_show = true,
            window = {
                border = "rounded",
            },
        },
    },
    cmdline = {
        enabled = true,
        completion = {
            list = { selection = { preselect = false } },
        },
        keymap = {
            preset = "default",
        },
    },
    term = {
        enabled = true,
    }
})


require('nvim-treesitter').setup({
    ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "haskell",
        "json",
        "latex",
        "lua",
        "ocaml",
        "python",
        "qml",
        "rust",
        "toml",
        "typst",
        "vim",
        "yaml",
    },
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = "<C-s>",
            node_decremental = "<M-space>",
        },
    },
})

require("nvim-treesitter-textobjects").setup({})

-----------------------------------------------------------
--- LINTING
-----------------------------------------------------------

local lint = require("lint")

lint.linters_by_ft = {
    rust = { "clippy" },
    ocaml = { "ocamlmerlin" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
    end,
})

require('conform').setup({
    formatters_by_ft = {
        haskell = { "fourmolu", lsp_format = "fallback" }
    },
    format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
    },
})
