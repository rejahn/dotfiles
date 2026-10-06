vim.pack.add({
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/neovim/nvim-lspconfig",
})

vim.diagnostic.config({
	virtual_text = false,
	underline = false,
	update_in_insert = true,
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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

local on_attach = function(client, bufnr)
	require("keymaps").lsp_attach(client, bufnr)

	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end
end

-- Common config
local function setup(name, config)
	config = config or {}
	config.on_attach = on_attach
	config.capabilities = capabilities
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

setup("lua_ls", {
	settings = {
		Lua = { diagnostics = { globals = { "vim" } } },
	},
})

setup("rust_analyzer", {
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

setup("clangd", {
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
})

setup("ruff", {
	cmd = { "ruff", "server" },
	init_options = {
		settings = { configurationPreference = "filesystemFirst" },
	},
})

setup("ty", {
	cmd = { "ty", "server" },
	settings = { ty = {} },
})

setup("jsonls")

setup("yamlls", {
	settings = {
		yaml = {
			format = {
				enable = true,
				bracketSpacing = false,
				printWidth = 120,
			},
		},
	},
})
