hl = hl

mainMod = "SUPER"

local nix = require("nix")

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
	general = {
		allow_tearing = true,

		gaps_in = 2,
		gaps_out = 4,
		border_size = 1,

		col = {
			active_border = "rgba(ffffffee)",
			inactive_border = "rgba(00000000)",
		}
	},

	decoration = {
		shadow = { enabled = false },

		blur = {
			enabled = true,
			size = 4,
			passes = 1
		}
	},

	animations = { enabled = true },

	xwayland = {
		force_zero_scaling = true
	},

	misc = {
		disable_xdg_env_checks = true,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		disable_autoreload = true,
		force_default_wallpaper = true,
	},

	ecosystem = {
		no_update_news = true,
		no_donation_nag = true
	},

	cursor = {
		no_hardware_cursors = 2,
		no_break_fs_vrr = 2
	}
})


-- Input
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 2,
		sensitivity = 0,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true
		}
	}
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
	bitdepth = 10
})


hl.bind(mainMod .. " + CTRL + Backspace", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("uwsm-app -- " .. nix.terminal))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("uwsm-app -- " .. nix.fuzzel))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

hl.window_rule({
	name = "enable-steam-tearing",
	match = { class = "^(steam_app_[0-9]+)$" },
	immediate = true
})

hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { .3, 1 } } })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "easeOutExpo" })
hl.animation({ leaf = "global", enabled = false })

require("layout").setup({ modifier = mainMod, animation = { speed = 3, bezier = "easeOutExpo" } })
