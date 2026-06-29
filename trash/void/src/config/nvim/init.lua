-- =============================================================================
-- OPTIONS
-- =============================================================================
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
-- =============================================================================
-- KEYMAPS
-- =============================================================================
local map = vim.api.nvim_set_keymap

vim.g.mapleader = " "

map("i", "jk", "<esc>", {})
map("n", "<leader>w", ":w<cr>", {})
map("n", "<leader>x", ":bdelete<cr>", {})
map("n", "<leader>c", ":!", {})
map("n", "<leader>nh", ":nohl<cr>", {})
map("n", "<leader>ff", ":FZF<cr>", {})
map("n", "<leader>1", "<C-w>w", {})

vim.keymap.set("n", "<leader>hh", function()
	local current_diag = vim.diagnostic.config()
	local diag_status = true
	if current_diag and current_diag.virtual_text ~= nil then
		diag_status = not current_diag.virtual_text
	end
	vim.diagnostic.config({ virtual_text = diag_status })
	local hint_status = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
	vim.lsp.inlay_hint.enable(hint_status, { bufnr = 0 })
	local msg = string.format(
		"LSP View -> diagnostics-text: %s | Inlay Hints: %s",
		diag_status and "on" or "off",
		hint_status and "on" or "off"
	)
	vim.notify(msg, vim.log.levels.INFO)
end, { desc = "Toggle Virtual Text and Inlay Hints" })

-- =============================================================================
-- STATUSLINE
-- =============================================================================
function _G.get_lsp_and_formatter()
	local lsps, fmts = {}, {}
	local lsp_ok, clients = pcall(vim.lsp.get_clients, { bufnr = 0 })
	for _, c in ipairs(lsp_ok and clients or {}) do
		table.insert(lsps, c.name)
	end

	local cf_ok, cf = pcall(require, "conform")
	local fmt_ok, formatters = pcall(cf_ok and cf.list_formatters or function() end, 0)
	for _, f in ipairs(fmt_ok and formatters or {}) do
		if f.available then
			table.insert(fmts, f.name)
		end
	end

	return (#lsps > 0 and "[" .. table.concat(lsps, ",") .. "]" or "[-]")
		.. " | "
		.. (#fmts > 0 and "[" .. table.concat(fmts, ",") .. "]" or "[-]")
end

vim.opt.statusline = "%F %m %r %y %= %{v:lua._G.get_lsp_and_formatter()}  %l:%c %P"

-- =============================================================================
-- USER COMMANDS
-- =============================================================================
vim.api.nvim_create_user_command("E", function()
	vim.cmd("edit $MYVIMRC")
end, { desc = "edit config" })

-- =============================================================================
-- PACKAGE MANAGER
-- =============================================================================
vim.pack.add({
	{ src = "https://github.com/junegunn/fzf.vim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/mrcjkb/rustaceanvim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/marko-cerovac/material.nvim" },
	{ src = "https://github.com/romus204/tree-sitter-manager.nvim" },
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
})
vim.cmd([[colorscheme material-palenight]])

-- =============================================================================
-- PLUGINS CONFIGURATION
-- =============================================================================
vim.keymap.set("n", "<leader>e", function()
	local oil = require("oil")
	local oil_win = nil

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "oil" then
			oil_win = win
			break
		end
	end

	if oil_win then
		vim.api.nvim_win_close(oil_win, true)
	else
		vim.cmd("topleft vsplit | vertical resize 30")
		oil.open()
	end
end, { desc = "Toggle Oil Sidebar" })

require("oil").setup({
	keymaps = {
		["<CR>"] = {
			callback = function()
				local oil = require("oil")
				local entry = oil.get_cursor_entry()

				if entry and entry.type == "file" then
					local filepath = oil.get_current_dir() .. entry.name
					local target_win = nil

					for _, win in ipairs(vim.api.nvim_list_wins()) do
						if vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "oil" then
							target_win = win
							break
						end
					end

					if target_win then
						vim.api.nvim_set_current_win(target_win)
						vim.cmd("edit " .. vim.fn.fnameescape(filepath))
					else
						vim.cmd("vsplit " .. vim.fn.fnameescape(filepath))
					end
				else
					oil.select()
				end
			end,
			desc = "Open file in main code window",
		},
	},
})

require("nvim-autopairs").setup({})

require("tree-sitter-manager").setup({
	border = "rounded",
	auto_install = true,
	noauto_install = {},
	highlight = true,
	nerdfont = true,
})

require("blink.cmp").setup({})

require("fidget").setup({})
vim.notify = require("fidget").notify

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		rust = { "rustfmt" },
		javascript = { "prettier" },
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
})

-- =============================================================================
-- CORE LSP CONFIGURATION
-- =============================================================================
vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" },
			diagnostics = { globals = { "vim" } },
			workspace = { library = { vim.env.VIMRUNTIME } },
			hint = { enable = true },
		},
	},
})
vim.lsp.enable("lua_ls")

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--inlay-hints=true",
	},
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
	root_markers = { ".git", "compile_commands.json", "compile_flags.txt" },
})
vim.lsp.enable("clangd")

-- =============================================================================
-- MODULE: WEB DEVELOPMENT OVERRIDE
-- =============================================================================
function WEBDEV()
	require("conform").setup({
		formatters_by_ft = {
			nix = { "nixfmt" },
			lua = { "stylua" },
			html = { "prettier" },
			jsx = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			less = { "prettier" },
			vue = { "prettier" },
			svelte = { "prettier" },
			markdown = { "prettier" },
			yaml = { "prettier" },
		},
		format_on_save = {
			timeout_ms = 500,
			lsp_format = "fallback",
		},
	})

	vim.pack.add({
		{ src = "https://github.com/neovim/nvim-lspconfig" },
		{ src = "https://github.com/rafamadriz/friendly-snippets" },
		{ src = "https://github.com/L3MON4D3/LuaSnip" },
	})

	require("luasnip.loaders.from_vscode").load({})

	local servers = {
		"emmet_ls",
		"vtsls",
		"html",
		"cssls",
		"jsonls",
		"eslint",
		"vue_ls",
		"svelte",
		"tailwindcss",
	}
	vim.lsp.enable(servers)
	--[[
    --setup  all lsp for wbdev
    --creae dir
    --"mkdir -p ~/.local/npm-glob"
    --setup npm prefix global
    --"npm config set ~/.local/npm-glob"
    --add to path
    --export PATH="$HOME/.local/npm-glob/bin:$PATH"
    --install all
    --npm install -g emmet-ls@latest @vtsls/language-server@latest vscode-langservers-extracted@latest eslint@latest @vue/language-server@latest svelte-language-server@latest tailwindcss-language-server@latest prettier@latest
    --]]
end

--WEBDEV()
