local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Atur padding menjadi 0 agar teks mepet ke pinggir (mengurangi spasi hitam)
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- Menghilangkan ruang kosong ekstra saat window di-maximize
config.adjust_window_size_when_changing_font_size = false

-- Konfigurasi Dasar
config.default_prog = { "powershell.exe", "-NoExit" }
config.font = wezterm.font("SFMono Nerd Font")
config.font_size = 9

-- ====================================================================
-- KONFIGURASI TAB BAR BASIC & MINIMALIS
-- ====================================================================
config.use_dead_keys = false
config.tab_bar_at_bottom = true -- Memindahkan tab bar ke bawah
config.use_fancy_tab_bar = false -- Menggunakan text-based tab bar agar minimalis
config.tab_max_width = 32

-- Palet Warna Tema (Dusk/Nord Style)
local colors = {
	bg = "#1a1b26",
	active_bg = "#7aa2f7",
	active_fg = "#15161e",
	inactive_bg = "#24283b",
	inactive_fg = "#c0caf5",
}

config.colors = {
	tab_bar = {
		background = colors.bg,
	},
}

-- Format Tampilan Tab (Sederhana, Tanpa Efek Rounded Lengkung)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = colors.inactive_bg
	local foreground = colors.inactive_fg

	if tab.is_active then
		background = colors.active_bg
		foreground = colors.active_fg
	end

	-- Format teks langsung dengan spasi pemisah yang bersih
	local title = "  " .. tab.tab_index + 1 .. ": " .. tab.active_pane.title .. "  "

	return {
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
	}
end)

-- Status Bar Sebelah Kanan (Hanya Teks & Icon Jam)
wezterm.on("update-status", function(window, pane)
	local date = wezterm.strftime(" %Y-%m-%d %H:%M ")

	window:set_right_status(wezterm.format({
		{ Background = { Color = colors.bg } },
		{ Foreground = { Color = colors.inactive_fg } },
		{ Text = "" .. date },
	}))
end)
-- ====================================================================

-- Shortcuts / Keybindings
config.keys = {
	-- Ctrl + Shift + H untuk pindah ke tab kiri
	{
		key = "H",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	-- Ctrl + Shift + L untuk pindah ke tab kanan
	{
		key = "L",
		mods = "CTRL|SHIFT",
		action = wezterm.action.ActivateTabRelative(1),
	},
}

return config
