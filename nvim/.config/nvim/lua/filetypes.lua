local ansible_markers = {
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
}

local function yaml_filetype(path)
	local directory = vim.fs.dirname(path)
	while directory do
		for _, marker in ipairs(ansible_markers) do
			if vim.uv.fs_stat(vim.fs.joinpath(directory, marker)) then
				return "yaml.ansible"
			end
		end

		if vim.uv.fs_stat(vim.fs.joinpath(directory, ".git")) then
			break
		end

		local parent = vim.fs.dirname(directory)
		if parent == directory then
			break
		end
		directory = parent
	end
	return "yaml"
end

vim.filetype.add({
	extension = {
		yml = yaml_filetype,
		yaml = yaml_filetype,
	},
})
