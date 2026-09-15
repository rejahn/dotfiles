vim.pack.add({
	"https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_organize_imports", "ruff_format" },
		rust = { "rustfmt" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		objc = { "clang_format" },
		objcpp = { "clang_format" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
	},

	formatters = {
		prettier = {
			prepend_args = { "--tab-width", "4" },
		},
	},

	format_on_save = function(bufnr)
		return {
			bufnr = bufnr,
			timeout_ms = 1000,
			lsp_format = "fallback",
		}
	end,
})
