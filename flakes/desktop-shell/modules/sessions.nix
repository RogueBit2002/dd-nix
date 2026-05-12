{ inputs, ... }: {
	perSystem = { config, system, pkgs, lib, ... }: {
		packages.session = pkgs.callPackage
			({ terminal, font-family, hyprland, ... }@overrides: let
				start-hyprland = lib.getExe' hyprland "start-hyprland";
				hyprland-config = config.packages.hyprland-config.override overrides;

			in pkgs.writeTextFile {
					name = "desktop-shell-session";
					destination = "/share/wayland-sessions/desktop-shell.desktop";
					text = ''
[Desktop Entry]
Name=Hyprland (Desktop-Shell)
Comment=Hyprland based tui desktop environment
Exec=${start-hyprland} -- --config ${hyprland-config}/hyprland.lua
Type=Application
DesktopNames=Hyprland
Keywords=tiling;wayland;compositor;
'';
				})
			{
				terminal = pkgs.kitty;
				font-family = null;
				kanshi-config = null;
			};
	};
}
