local M = {}
local Snacks

vim.keymap.set("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlights" })

vim.keymap.set("x", "p", [["_dP]], { desc = "Paste over selection without losing yanked text" })

-- map for quick quit, save files using leader key
vim.keymap.set("n", "<Leader>w", ":write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<Leader>x", ":wq<CR>", { desc = "Save and quit" })

-- improve indentation
vim.keymap.set("v", "<", "<gv", { desc = "Unindent and keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })

-- centered cursor
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down in buffer with cursor centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up in buffer with cursor centered" })

-- Prefix labels for mini.clue; actual bindings supply their own descriptions.
M.clues = {
	{ mode = { "n", "x" }, keys = "gs", desc = "Surround" },
	{ mode = "n", keys = "<leader>b", desc = "Buffers" },
	{ mode = "n", keys = "<leader>c", desc = "Code" },
	{ mode = "n", keys = "<leader>d", desc = "Diagnostics" },
	{ mode = "n", keys = "<leader>f", desc = "Find" },
	{ mode = { "n", "x" }, keys = "<leader>g", desc = "Git" },
	{ mode = "n", keys = "<leader>q", desc = "Sessions" },
	{ mode = "n", keys = "<leader>s", desc = "Search" },
	{ mode = "n", keys = "<leader>t", desc = "Toggles" },
}

-- Pickers, explorer, Git, and toggles
function M.snacks(snacks)
	Snacks = snacks
	local picker = Snacks.picker
	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true })
	end

	map("<leader>ff", picker.files, "Find files")
	map("<leader>fb", picker.buffers, "Buffers")
	map("<leader>fj", picker.jumps, "Jumplist")
	map("<leader>lg", function()
		Snacks.lazygit()
	end, "Lazygit")
	map("<leader>f:", picker.command_history, "Command History")
	map("<leader>fg", picker.grep, "Live grep")
	map("<leader>fc", picker.commands, "Commands")
	map("<leader>fh", picker.help, "Help tags")
	map("<leader>fr", picker.lsp_references, "References")
	map("<leader>e", function()
		Snacks.explorer({ layout = { hidden = { "input" }, layout = { position = "right" } } })
	end, "File Explorer")
	map("<leader>tt", function()
		Snacks.terminal()
	end, "Toggle Terminal")
end

-- Bufferline
function M.bufferline()
	vim.keymap.set("n", "H", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
	vim.keymap.set("n", "L", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

	vim.keymap.set("n", "<leader>bh", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
	vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })
end

-- Named workspace sessions
function M.sessions()
	vim.keymap.set("n", "<leader>qs", function()
		vim.ui.input({ prompt = "Save session as: ", default = vim.fs.basename(vim.fn.getcwd()) }, function(name)
			if name == nil or vim.trim(name) == "" then
				return
			end
			require("mini.sessions").write(vim.trim(name))
		end)
	end, { desc = "Save Session" })

	vim.keymap.set("n", "<leader>qS", function()
		require("mini.sessions").select()
	end, { desc = "Select Session" })

	vim.keymap.set("n", "<leader>ql", function()
		local sessions = require("mini.sessions")
		local latest = sessions.get_latest()
		if latest then
			sessions.read(latest)
		else
			vim.notify("No saved sessions", vim.log.levels.INFO)
		end
	end, { desc = "Restore Last Session" })

	vim.keymap.set("n", "<leader>qd", function()
		vim.v.this_session = ""
	end, { desc = "Stop Session Saving" })
end

-- Buffer-local LSP bindings
function M.lsp_attach(client, bufnr)
	local map = function(lhs, rhs, desc)
		vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
	end

	vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
	map("<leader>a", vim.lsp.buf.code_action, "Code actions")
	map("<leader>fd", Snacks.picker.diagnostics_buffer, "Document diagnostics")
	map("<leader>fD", Snacks.picker.diagnostics, "Workspace diagnostics")
	map("<leader>fs", Snacks.picker.lsp_symbols, "Document symbols")
	map("<leader>fS", Snacks.picker.lsp_workspace_symbols, "Workspace symbols")
	map("<leader>r", vim.lsp.buf.rename, "Rename symbol")
	map("gd", Snacks.picker.lsp_definitions, "Goto Definition")
	map("gD", Snacks.picker.lsp_declarations, "Goto Declaration")
	map("gr", Snacks.picker.lsp_references, "References")
	map("gi", Snacks.picker.lsp_implementations, "Goto Implementation")
	map("gy", Snacks.picker.lsp_type_definitions, "Goto Type Definition")

	if client.name == "clangd" then
		vim.keymap.set("n", "<leader>ch", function()
			require("clangd_extensions.switch_source_header").switch_source_header()
		end, { buffer = bufnr, desc = "C/C++: Switch Source/Header" })
	end
end

-- Completion preset
M.completion = { preset = "enter" }

return M
