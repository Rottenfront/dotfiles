return {
  -- {
  --   "andrewferrier/wrapping.nvim",
  --   config = function()
  --     require("wrapping").setup()
  --   end,
  -- },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-buffer", "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path" },
    ---@param opts cmp.ConfigSchema
    opts = {
      sources = {
        "nvim_lsp",
        "buffer",
        "path",
      },
    },
  },
}
