return {
  { "rebelot/kanagawa.nvim", name = "kanagawa", priority = 1000 },
  "xiyaowong/transparent.nvim",
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
  },
}
