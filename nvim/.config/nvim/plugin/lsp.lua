vim.pack.add({
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

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		require("keymaps").lsp_attach(client, ev.buf)

		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
		end
	end,
})

-- Common config
local function setup(name, config)
	config = config or {}
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

setup("ts_ls")
setup("html")
setup("cssls")

setup("astro", {
	before_init = function(_, config)
		local tsdk = require("lspconfig.util").get_typescript_server_path(config.root_dir)
		if tsdk == "" then
			tsdk = vim.fs.joinpath(
				vim.fn.stdpath("data"),
				"mason/packages/astro-language-server/node_modules/typescript/lib"
			)
		end
		config.init_options = config.init_options or {}
		config.init_options.typescript = config.init_options.typescript or {}
		config.init_options.typescript.tsdk = tsdk
	end,
})

local ansible_bin = vim.fs.joinpath(vim.fn.stdpath("data"), "mason/packages/ansible-lint/venv/bin")

setup("ansiblels", {
	-- Keep Ansible's helper commands and Python in the same Mason environment.
	cmd_env = { PATH = ansible_bin .. ":" .. vim.env.PATH },
	settings = {
		ansible = {
			python = { interpreterPath = vim.fs.joinpath(ansible_bin, "python") },
			ansible = { path = vim.fs.joinpath(ansible_bin, "ansible") },
		},
	},
	root_markers = {
		"ansible.cfg",
		".ansible-lint",
		".ansible-lint.yml",
		".ansible-lint.yaml",
		"inventory.ini",
		"all.yml",
		"all.yaml",
		"roles",
		"group_vars",
		"host_vars",
		"playbooks",
		".git",
	},
})

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
