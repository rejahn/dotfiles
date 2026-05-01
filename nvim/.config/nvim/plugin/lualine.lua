vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
})

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = " ", right = " " },
    section_separators = { left = " ", right = " " },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
        sections = { "error", "warn" },
        symbols = {
          error = "●",
          warn = "●",
        },
      },
      { "filename", path = 1 },
    },
    lualine_x = {
      {
        "filetype",
        colored = true,
      },
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})
