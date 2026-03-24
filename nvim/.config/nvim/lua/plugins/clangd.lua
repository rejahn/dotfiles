return {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp" },
  opts = {
    inlay_hints = {
      inline = true,
    },
  },
  config = function(_, opts)
    require("lsp.cpp").setup_clangd_extensions(opts)
  end,
}
