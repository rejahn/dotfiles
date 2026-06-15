local M = {}

function M.setup_lsp(on_attach, capabilities)
	vim.lsp.config("clangd", {
		filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			if on_attach then
				on_attach(client, bufnr)
			end
			vim.keymap.set(
				"n",
				"<leader>ch",
				require("clangd_extensions.switch_source_header").switch_source_header,
				{ buffer = bufnr, desc = "C/C++: Switch Source/Header" }
			)
		end,
	})
	vim.lsp.enable("clangd")
end

function M.setup_clangd_extensions(opts)
	require("clangd_extensions").setup(opts)
end

return M
