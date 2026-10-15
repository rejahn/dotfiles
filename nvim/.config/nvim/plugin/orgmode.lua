vim.pack.add({ "https://github.com/nvim-orgmode/orgmode" })

-- Setup orgmode
require("orgmode").setup({
	org_agenda_files = "~/orgfiles/**/*",
	org_default_notes_file = "~/orgfiles/refile.org",
})

-- Experimental LSP support
vim.lsp.enable("org")
