_G.fmt_status = function()
	local ok, conform = pcall(require, "conform")
	if not ok then
		return ""
	end
	return table.concat(
		vim.tbl_map(function(f)
			return vim.fn.executable(f.command) == 1 and ("{" .. f.name .. " active}") or (f.name .. " missing")
		end, conform.list_formatters(0)),
		" "
	)
end

vim.opt.statusline = "%f %m %= %{%v:lua.fmt_status()%} %l:%c"
local o = vim.opt

o.number = true
o.relativenumber = true
o.termguicolors = true
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.clipboard = "unnamedplus"
o.mouse = "a"
o.updatetime = 250
o.textwidth = 80
o.colorcolumn = "80"
o.completeopt = { "menuone", "noselect", "popup" }

local map = vim.api.nvim_set_keymap
vim.g.mapleader = " "
map("i", "jk", "<esc>", {})
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>x", ":bdelete<cr>", {})
map("n", "<leader>c", ":!", {})
map("n", "<leader>nh", ":nohl<cr>", {})
map("n", "<leader>e", ":Ex<cr>", {})
map("n", "<leader>ff", ":FzfLua files<cr>", {})

vim.pack.add({
	{
		src = "https://github.com/ibhagwan/fzf-lua",
	},
	{
		src = "https://github.com/stevearc/conform.nvim",
	},
	{
		src = "https://github.com/windwp/nvim-autopairs",
	},
	{
		src = "https://github.com/romus204/tree-sitter-manager.nvim",
	},
	{
		src = "https://github.com/folke/tokyonight.nvim",
	},
})
vim.cmd([[colorscheme tokyonight-night]])
require("nvim-autopairs").setup({})
require("tree-sitter-manager").setup({
	auto_install = true,
	highlight = true,
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		c = { "clang-format" },
		h = { "clang-format" },
		cpp = { "clang-format" },
		hpp = { "clang-format" },
		nix = { "nixfmt" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		html = { "prettier" },
		jsx = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		less = { "prettier" },
		vue = { "prettier" },
		svelte = { "prettier" },
		markdown = { "prettier" },
		yaml = { "prettier" },
		sh = { "shfmt" },
		zig = { "zigfmt" },
		toml = { "taplo" },
		go = { "gofmt" },
		bash = { "shfmt" },
	},
	format_on_save = {
		lsp_format = false,
	},
})
