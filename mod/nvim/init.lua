local opt = vim.opt

-- Tampilan UI
opt.number = true -- Baris angka
opt.relativenumber = true -- Baris angka relatif (untuk navigasi cepat)
opt.cursorline = true -- Highlight baris kursor
opt.termguicolors = true -- Warna 24-bit
opt.signcolumn = "yes" -- Selalu tampilkan kolom ikon (LSP/Git)
opt.scrolloff = 10 -- Minimal 10 baris di atas/bawah kursor saat scroll

	-- Tab & Indentasi
	.opt
	.tabstop = 2 -- Lebar tab
opt.shiftwidth = 2 -- Lebar indentasi
opt.expandtab = true -- Spasi sebagai tab
opt.smartindent = true -- Indentasi otomatis cerdas

-- Pencarian & Sistem
opt.ignorecase = true -- Case-insensitive search
opt.smartcase = true -- Sensitive jika ada huruf kapital
opt.updatetime = 250 -- Delay update (milidetik)
opt.clipboard = "unnamedplus" -- Gunakan clipboard sistem
opt.mouse = "a" -- Aktifkan mouse
opt.undofile = true -- Simpan riwayat undo selamanya
opt.swapfile = false -- Jangan buat file swap

-- Global Variables
vim.g.mapleader = " " -- Spasi sebagai Leader

local keymap = vim.keymap.set
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>e", ":Ex<CR>", { desc = "Explorer" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", ":bdelete<CR>", { desc = "Quit" })
keymap("i", "jk", "<Esc>", { desc = "Quit" })
-- Buffers (Navigasi tab atas)
keymap("n", "<Tab>", ":bnext<CR>")
keymap("n", "<S-Tab>", ":bprevious<CR>")
-- formater
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "nixfmt" },
		json = { "jq" },
		rust = { "rustfmt" },
		python = { "black" },
		htmldjango = { "djlint" },
		html = { "djlint" },
		javascript = { "prettier" },
	},
})
vim.pack.add({
	{ src = "https://github.com/folke/lazydev.nvim" },
})
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".luarc.json", ".git" },
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the 'vim' global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false, -- Disable checking of third-party files
			},
			-- Other settings (e.g., completion, format) can go here
			telemetry = {
				enable = false,
			},
		},
	},
})
vim.lsp.config("nixd", {
	cmd = { "nixd" },
	settings = {
		nixd = {
			nixpkgs = {
				-- For flake.
				-- This expression will be interpreted as "nixpkgs" toplevel
				-- Nixd provides package, lib completion/information from it.
				-- Resource Usage: Entries are lazily evaluated, entire nixpkgs takes 200~300MB for just "names".
				-- Package documentation, versions, are evaluated by-need.
				expr = "import (builtins.getFlake(toString ./.)).inputs.nixpkgs { }",
			},
			formatting = {
				command = { "nixfmt" }, -- or nixfmt or nixpkgs-fmt
			},
			options = {
				nixos = {
					expr = "let flake = builtins.getFlake(toString ./.); in flake.nixosConfigurations.DESKTOP-CO3EUIG.options",
				},
				home_manager = {
					expr = 'let flake = builtins.getFlake(toString ./.); in flake.homeConfigurations."mor@DESKTOP-CO3EUIG".options',
				},
			},
		},
	},
})

-- Enable the server
vim.lsp.enable("lua_ls")
vim.lsp.enable("nixd")

require("lazydev").setup({})
-- completions
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" },
})
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = { documentation = { auto_show = true } },
	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer" },
		providers = {
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
		},
	},
	fuzzy = { implementation = "prefer_rust" },
})
--: telescope
vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
--:
