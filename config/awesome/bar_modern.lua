local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local modern_bar = {}

function modern_bar.setup(s, tasklist_buttons)
	-- Ukuran font custom (sesuaikan angka 12 atau 14 sesuai selera)
	-- Tambahkan baris ini di dalam fungsi modern_bar.setup(s, ...)
	-- Widget Network Traffic
	-- Widget Network Traffic macOS Style
	local net_speed_widget = wibox.widget({
		{
			{
				-- Ikon Minimalis
				{
					text = "NET", -- Gunakan ikon SF Symbols jika ada, atau "󰓅" dari Nerd Font
					font = "JetBrainsMono Nerd Font 8",
					widget = wibox.widget.textbox,
					valign = "center",
					align = "center",
				},
				{
					-- Baris Atas (Download) & Bawah (Upload)
					{
						id = "rx_speed",
						text = "0.0 K/s",
						font = "Sans Bold 7", -- Font kecil khas macOS
						widget = wibox.widget.textbox,
					},
					{
						id = "tx_speed",
						text = "0.0 K/s",
						font = "Sans Bold 7",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.vertical, -- Teks bertumpuk
					spacing = -2,
				},
				layout = wibox.layout.fixed.horizontal,
				spacing = 8,
			},
			left = 10,
			right = 10,
			widget = wibox.container.margin,
		},
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 6)
		end,
		bg = "#ffffff10", -- Background tipis (glassmorphism)
		widget = wibox.container.background,
	})

	local interface = "wlp0s26u1u1"
	local prev_rx, prev_tx = 0, 0

	gears.timer({
		timeout = 1,
		call_now = true,
		autostart = true,
		callback = function()
			local f = io.open("/proc/net/dev")
			if not f then
				return
			end
			local content = f:read("*all")
			f:close()

			local rx, tx = content:match(interface .. ":%s+(%d+)%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+%d+%s+(%d+)")

			if rx and tx then
				rx, tx = tonumber(rx), tonumber(tx)
				if prev_rx > 0 then
					local speed_rx = (rx - prev_rx) / 1024
					local speed_tx = (tx - prev_tx) / 1024

					-- Update Download (Atas)
					net_speed_widget:get_children_by_id("rx_speed")[1].markup = string.format(
						"<span color='#ffffff'>DL:</span> <span color='#a6adc8'>%.1f K/s</span>",
						speed_rx
					)

					-- Update Upload (Bawah)
					net_speed_widget:get_children_by_id("tx_speed")[1].markup = string.format(
						"<span color='#ffffff'>UL:</span> <span color='#a6adc8'>%.1f K/s</span>",
						speed_tx
					)
				end
				prev_rx, prev_tx = rx, tx
			end
		end,
	})

	-- Tentukan berapa pixel area monitor yang rusak (misal 30px)
	local dead_zone = 30

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		height = 24,
		-- Ini kunci utamanya: Menambahkan margin atas sebesar area yang rusak
		margins = {
			top = dead_zone,
			left = 10, -- Opsional: agar lebih estetik (floating)
			right = 10,
		},
		shape = function(cr, w, h)
			gears.shape.rounded_rect(cr, w, h, 8)
		end,
		bg = "#1a1b26",
	})
	local main_font = "Sans Bold 8"

	-- 1. Definisikan Tasklist: Hanya Icon (Font tidak berpengaruh di sini karena icon only)
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		layout = {
			spacing = 8,
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "clienticon",
						widget = wibox.widget.imagebox,
					},
					margins = 6,
					widget = wibox.container.margin,
				},
				id = "background_role", -- Ini kunci untuk status aktif
				widget = wibox.container.background,
			},
			-- Membuat bentuk "Pill" atau kotak tumpul untuk indikator aktif
			create_callback = function(self, c, index, objects)
				self:get_children_by_id("clienticon")[1].image = c.icon
				-- Tambahkan shape bulat pada background agar modern
				self:get_children_by_id("background_role")[1].shape = function(cr, w, h)
					gears.shape.rounded_rect(cr, w, h, 6)
				end
			end,
			widget = wibox.container.margin,
		},
	})
	-- 2. Jam dengan font lebih besar
	local mytextclock = wibox.widget.textclock()
	mytextclock.font = main_font

	-- 3. Taglist (Workspace) dengan font lebih besar
	-- Kita override font taglist bawaan di sini
	s.mytaglist.font = main_font
	--title
	s.mytitlewidget = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.focused, -- Hanya ambil yang sedang fokus
		layout = { layout = wibox.layout.fixed.horizontal },
		widget_template = {
			{
				id = "text_role",
				widget = wibox.widget.textbox,
			},
			layout = wibox.container.margin,
			left = 10,
			right = 10,
		},
	})

	-- Susunan Wibar
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		{ -- KIRI
			layout = wibox.layout.fixed.horizontal,
			s.mylaucher,
			s.mytitlewidget,
			s.mytitlewidget,
		},
		{ -- TENGAH
			layout = wibox.layout.fixed.horizontal,
			s.mytaglist,
		},
		{ -- KANAN
			layout = wibox.layout.fixed.horizontal,
			spacing = 12,
			s.mytasklist,
			wibox.widget.systray(),
			mytextclock, -- Menggunakan jam yang sudah diperbesar font-nya
			net_speed_widget,
			s.mylayoutbox,
		},
	})
end

return modern_bar
