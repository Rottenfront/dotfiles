return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "rust",
        "c",
        "cpp",
        "ocaml",
        "haskell",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "clangd",
        "ocaml-lsp",
        "codelldb",
        "taplo",
        "texlab",
      },
    },
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = function(_, _)
  --     local lspconfig = require("lspconfig")
  --     lspconfig.racket_langserver.setup()
  --     lspconfig.r_language_server.setup()
  --   end,
  -- },
}
