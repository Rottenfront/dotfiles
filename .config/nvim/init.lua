local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure lazy.nvim
require("lazy").setup({
    -- ============================================================================
    -- UI & Notifications
    -- ============================================================================
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
    },

    -- ============================================================================
    -- Core Development Tools
    -- ============================================================================
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "mason.nvim",
            "mason-lspconfig.nvim",
        },
        setup = function()

        end
    },

    {
        "mason-org/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },

    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                -- Rust
                "rust_analyzer",
                -- Python
                "pyright",
                "pylsp",
                -- C/C++
                "clangd",
                -- OCaml
                "ocamllsp",
                -- LaTeX
                "texlab",
                -- JSON/YAML/TOML
                "jsonls",
                "yamlls",
                "taplo",
                -- Lua
                "lua_ls",
                -- Typst
                "tinymist",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({})
                end,
                ["rust_analyzer"] = function()
                    require("lspconfig").rust_analyzer.setup({
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
                end,
                ["clangd"] = function()
                    require("lspconfig").clangd.setup({
                        cmd = {
                            "clangd",
                            "--background-index",
                            "--clang-tidy",
                            "--header-insertion=iwyu",
                        },
                    })
                end,
                ["pyright"] = function()
                    require("lspconfig").pyright.setup({
                        settings = {
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "workspace",
                                    typeCheckingMode = "standard",
                                },
                            },
                        },
                    })
                end,
                ["ocamllsp"] = function()
                    require("lspconfig").ocamllsp.setup({})
                end,
                ["texlab"] = function()
                    require("lspconfig").texlab.setup({
                        settings = {
                            texlab = {
                                auxDirectory = ".",
                                bibtexFormatter = "texlab",
                                build = {
                                    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
                                    executable = "latexmk",
                                    forwardSearchAfter = false,
                                    onSave = false,
                                },
                                chktex = {
                                    onEdit = false,
                                    onOpenAndSave = false,
                                },
                                diagnosticsDelay = 300,
                                formatterLineLength = 80,
                                forwardSearch = {
                                    args = {},
                                },
                                latexFormatter = "latexindent",
                                latexindent = {
                                    modifyLineBreaks = false,
                                },
                            },
                        },
                    })
                end,
            },
        },
    },

    -- ============================================================================
    -- Completion & Snippets
    -- ============================================================================
    {
        "saghen/blink.cmp",
        lazy = false,
        version = "1.*",
        opts = {
            keymap = {
                preset = "enter",
            },
            appearance = {
                use_nvim_cmp_as_default = false,
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
                    buffer = {
                        opts = {
                            disabled = { "number" }
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
        },
    },

    -- ============================================================================
    -- Treesitter
    -- ============================================================================
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        opts = {
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
                "rust",
                "toml",
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
        }
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        dependencies = "nvim-treesitter/nvim-treesitter",
    },

    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                rust = { "clippy" },
                -- cpp = { "clang_tidy" },
                -- c = { "clang_tidy" },
                ocaml = { "ocamlmerlin" },
            }

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },

    -- ============================================================================
    -- Debugging
    -- ============================================================================
    {
        "mfussenegger/nvim-dap",
        lazy = false,
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Rust debugging with CodeLLDB
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = "lldb-vscode",
                    args = { "--port", "${port}" },
                },
            }

            dap.configurations.rust = {
                {
                    name = "Launch",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }

            -- C/C++ debugging
            dap.adapters.gdb = {
                type = "executable",
                command = "gdb",
                args = { "-i", "mi" },
            }

            dap.configurations.c = {
                {
                    name = "Launch",
                    type = "gdb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                    stopAtEntry = true,
                },
            }
            dap.configurations.cpp = dap.configurations.c
        end,
    },

    -- ============================================================================
    -- Build Systems & Task Running
    -- ============================================================================
    {
        "stevearc/overseer.nvim",
        opts = {
            templates = { "builtin" },
            task_list = {
                direction = "bottom",
                min_height = 25,
                max_height = 25,
                default_detail = 1,
            },
        },
    },

    -- ============================================================================
    -- Git Integration
    -- ============================================================================
    {
        "tpope/vim-fugitive",
        lazy = false,
    },

    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        opts = {
            signs = {
                add = { text = "┃" },
                change = { text = "┃" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end
                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })
                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true })
            end,
        },
    },

    -- ============================================================================
    -- Fuzzy Finder & Navigation
    -- ============================================================================
    {
        "nvim-telescope/telescope.nvim",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            mirror = false,
                            preview_width = 0.5,
                        },
                    },
                    file_ignore_patterns = { "node_modules", ".git" },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
            require("telescope").load_extension("fzf")
        end,
    },

    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
            return vim.fn.executable("make") == 1
        end,
    },

    -- ============================================================================
    -- which.nvim - Key binding help
    -- ============================================================================
    {
        "folke/which-key.nvim",
        lazy = false,
        opts = {
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 9,
                },
                presets = {
                    operators = true,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            layout = {
                spacing = 6,
                align = "left",
            },
            show_help = true,
        },
    },

    -- ============================================================================
    -- Editor Features
    -- ============================================================================
    {
        "windwp/nvim-autopairs",
        lazy = false,
        opts = {
            check_ts = true,
        },
    },

    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            view = {
                width = 30,
            },
            renderer = {
                indent_markers = {
                    enable = true,
                },
            },
        },
    },

    {
        "akinsho/bufferline.nvim",
        lazy = false,
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                mode = "tabs",
                separator_style = "slant",
            },
        },
    },

    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                theme = "auto",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- ============================================================================
    -- Themes
    -- ============================================================================
    {
        "NopAngel/nimmy.vim",
        name = "nimmy",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("nimmy")
        end,
    },
}, {
    defaults = {
        lazy = true,
    },
    checker = {
        enabled = true,
        notify = false,
    },
})

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

-- Russian
keymap({ "n", "v", "o" }, "й", "q", opts)
keymap({ "n", "v", "o" }, "Й", "Q", opts)
keymap({ "n", "v", "o" }, "ф", "a", opts)
keymap({ "n", "v", "o" }, "Ф", "A", opts)
keymap({ "n", "v", "o" }, "я", "z", opts)
keymap({ "n", "v", "o" }, "Я", "Z", opts)
keymap({ "n", "v", "o" }, "ц", "w", opts)
keymap({ "n", "v", "o" }, "Ц", "W", opts)
keymap({ "n", "v", "o" }, "ы", "r", opts)
keymap({ "n", "v", "o" }, "Ы", "R", opts)
keymap({ "n", "v", "o" }, "ч", "x", opts)
keymap({ "n", "v", "o" }, "Ч", "X", opts)
keymap({ "n", "v", "o" }, "у", "f", opts)
keymap({ "n", "v", "o" }, "У", "F", opts)
keymap({ "n", "v", "o" }, "в", "s", opts)
keymap({ "n", "v", "o" }, "В", "S", opts)
keymap({ "n", "v", "o" }, "с", "c", opts)
keymap({ "n", "v", "o" }, "С", "C", opts)
keymap({ "n", "v", "o" }, "к", "p", opts)
keymap({ "n", "v", "o" }, "К", "P", opts)
keymap({ "n", "v", "o" }, "а", "t", opts)
keymap({ "n", "v", "o" }, "А", "T", opts)
keymap({ "n", "v", "o" }, "м", "v", opts)
keymap({ "n", "v", "o" }, "М", "V", opts)
keymap({ "n", "v", "o" }, "е", "g", opts)
keymap({ "n", "v", "o" }, "Е", "G", opts)
keymap({ "n", "v", "o" }, "п", "d", opts)
keymap({ "n", "v", "o" }, "П", "D", opts)
keymap({ "n", "v", "o" }, "и", "b", opts)
keymap({ "n", "v", "o" }, "И", "B", opts)
keymap({ "n", "v", "o" }, "н", "j", opts)
keymap({ "n", "v", "o" }, "Н", "J", opts)
keymap({ "n", "v", "o" }, "р", "h", opts)
keymap({ "n", "v", "o" }, "Р", "H", opts)
keymap({ "n", "v", "o" }, "т", "k", opts)
keymap({ "n", "v", "o" }, "Т", "K", opts)
keymap({ "n", "v", "o" }, "г", "l", opts)
keymap({ "n", "v", "o" }, "Г", "L", opts)
keymap({ "n", "v", "o" }, "о", "n", opts)
keymap({ "n", "v", "o" }, "О", "N", opts)
keymap({ "n", "v", "o" }, "ь", "m", opts)
keymap({ "n", "v", "o" }, "Ь", "M", opts)
keymap({ "n", "v", "o" }, "ш", "u", opts)
keymap({ "n", "v", "o" }, "Ш", "U", opts)
keymap({ "n", "v", "o" }, "л", "e", opts)
keymap({ "n", "v", "o" }, "Л", "E", opts)
keymap({ "n", "v", "o" }, "б", ",", opts)
keymap({ "n", "v", "o" }, "Б", "<", opts)
keymap({ "n", "v", "o" }, "щ", "y", opts)
keymap({ "n", "v", "o" }, "Щ", "Y", opts)
keymap({ "n", "v", "o" }, "д", "i", opts)
keymap({ "n", "v", "o" }, "Д", "I", opts)
keymap({ "n", "v", "o" }, "ю", ".", opts)
keymap({ "n", "v", "o" }, "Ю", ">", opts)
keymap({ "n", "v", "o" }, "з", ";", opts)
keymap({ "n", "v", "o" }, "З", ":", opts)
keymap({ "n", "v", "o" }, "ж", "o", opts)
keymap({ "n", "v", "o" }, "Ж", "O", opts)
keymap({ "n", "v", "o" }, "э", "'", opts)
keymap({ "n", "v", "o" }, "Э", "\"", opts)
keymap({ "n", "v", "o" }, "х", "[", opts)
keymap({ "n", "v", "o" }, "Х", "{", opts)
keymap({ "n", "v", "o" }, "ъ", "]", opts)
keymap({ "n", "v", "o" }, "Ъ", "}", opts)

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
-- LSP Configuration
-- ============================================================================
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

-- Auto-format on save
augroup("AutoFormat", { clear = true })
-- autocmd("BufWritePre", {
--     group = "AutoFormat",
--     callback = function()
--         require("conform").format({ async = true, lsp_fallback = true })
--     end,
-- })
