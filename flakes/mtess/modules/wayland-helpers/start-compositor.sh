#!/bin/sh

export PATH="/nix/store/vv77nkq74mq0ds7dg1xzip6dcgpslldm-hyprland-0.55.0+date=2026-05-16_24c5c13/bin:/nix/store/v70miqv3ppmg8q0k9am6krszj7xic4gm-xwayland-24.1.10/bin:/nix/store/hmp6dy13n85dvl1dp1q5jl1ysg3n0ssx-uwsm-0.24.3/bin:$PATH"

systemd-run \
	--scope \
	--user \
	--quiet \
	--property=Before=graphical-session.target \
	--property=BindsTo=graphical-session.target \
	--property=Wants=graphical-session-pre.target \
	--property=After=graphical-session-pre.target \
	-- /nix/store/vv77nkq74mq0ds7dg1xzip6dcgpslldm-hyprland-0.55.0+date=2026-05-16_24c5c13/bin/start-hyprland -- --config /nix/store/cka69lghrma712pg0vchsfjfq763nrjz-hyprland-config/hyprland.lua
