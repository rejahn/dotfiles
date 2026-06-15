local M = {}

function M.setup_lsp(on_attach, capabilities)
	vim.lsp.config("rust_analyzer", {
		filetypes = { "rust" },
		on_attach = on_attach,
		capabilities = capabilities,
		root_dir = function(bufnr, on_dir)
			local root = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), { "Cargo.toml" })
			if root then
				on_dir(root)
			end
		end,
		settings = {
			["rust-analyzer"] = {
				cargo = { features = "all" },
				check = { command = "clippy" },
			},
		},
	})
	vim.lsp.enable("rust_analyzer")
end

return M
