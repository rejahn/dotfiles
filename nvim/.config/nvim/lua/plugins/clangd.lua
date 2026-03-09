return {
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp", "objc", "objcpp" },
  opts = {
    inlay_hints = {
      inline = true,
    },
  },
  config = function(_, opts)
    require("clangd_extensions").setup(opts)
    vim.lsp.inlay_hint.enable(true)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "c", "cpp", "objc", "objcpp" },
      callback = function(ev)
        vim.keymap.set("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>",
          { buffer = ev.buf, desc = "C/C++: Switch Source/Header" })
      end,
    })
  end,
}