local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
    gh('NopAngel/nimmy.vim'),
    gh('folke/snacks.nvim'),
    gh('nvim-lua/plenary.nvim'),
    gh('nvim-tree/nvim-web-devicons'),
    gh('nvim-telescope/telescope-fzf-native.nvim'),
    gh('nvim-telescope/telescope.nvim'),
    gh('folke/which-key.nvim'),
    gh("windwp/nvim-autopairs"),
    gh("akinsho/bufferline.nvim"),
    gh("nvim-lualine/lualine.nvim"),
})

require('snacks').setup({
    notifier = {
        enabled = true,
        timeout = 3000,
    },
    statuscolumn = { enabled = true },
    words = { enabled = true },
})

vim.cmd.colorscheme("nimmy")

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
-- require("telescope").load_extension("fzf")

require("which-key").setup({
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
})

require('nvim-autopairs').setup({
    check_ts = true
})

require('bufferline').setup({
    options = {
        mode = "tabs",
        separator_style = "slant",
    },
})

require('lualine').setup({

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
})
