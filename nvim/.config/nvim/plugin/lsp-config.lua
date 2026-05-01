vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/Saghen/blink.cmp",
})

vim.diagnostic.config({
  virtual_text = false,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  virtual_lines = { current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "●",
      [vim.diagnostic.severity.WARN] = "●",
      [vim.diagnostic.severity.HINT] = "●",
      [vim.diagnostic.severity.INFO] = "●",
    },
  },
})

local capabilities = require("blink.cmp").get_lsp_capabilities()

local on_attach = function(_, bufnr)
  vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename symbol" })
  vim.keymap.set("n", "ga", "<C-^>", { desc = "Go to alternate buffer" })
end

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local preferred

    if ft == "rust" then
      preferred = "rust_analyzer"
    elseif ft == "c" or ft == "cpp" then
      preferred = "clangd"
    elseif ft == "python" then
      preferred = "ruff"
    end

    vim.lsp.buf.format({
      async = false,
      bufnr = ev.buf,
      filter = function(client)
        if preferred == "ruff" then
          return client.name == "ruff"
              and client.server_capabilities
              and client.server_capabilities.documentFormattingProvider
        end
        if preferred then
          return client.name == preferred
        end
        return client.server_capabilities.documentFormattingProvider
      end,
    })
  end,
})

vim.lsp.config("lua_ls", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})
vim.lsp.enable("lua_ls")

vim.lsp.config("bashls", { on_attach = on_attach, capabilities = capabilities })
vim.lsp.enable("bashls")

require("lsp.cpp").setup_lsp(on_attach, capabilities)

vim.lsp.config("autotools_ls", { on_attach = on_attach, capabilities = capabilities })
vim.lsp.enable("autotools_ls")

vim.lsp.config("taplo", { on_attach = on_attach, capabilities = capabilities })
vim.lsp.enable("taplo")

vim.lsp.config("jsonls", { on_attach = on_attach, capabilities = capabilities })
vim.lsp.enable("jsonls")

vim.lsp.config("nil_ls", { on_attach = on_attach, capabilities = capabilities })
vim.lsp.enable("nil_ls")

vim.lsp.config("ty", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "ty", "server" },
  settings = {
    ty = {},
  },
})
vim.lsp.enable("ty")

vim.lsp.config("ruff", {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "ruff", "server" },
  init_options = {
    settings = {
      configurationPreference = "filesystemFirst",
    },
  },
})
vim.lsp.enable("ruff")

require("lsp.rust").setup_lsp(on_attach, capabilities)
