{ inputs, ... }: {
	flake.homeModules.window-manager = { terminal, font-family, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;
		hyprland-pkgs = inputs.hyprland.packages.${system};
	in {

		home.packages = [
			pkgs.uwsm
			pkgs.kanshi
			(inputs.dd-desktop-shell.packages.${system}.session.override {
				
				hyprland = hyprland-pkgs.hyprland;
				inherit terminal;
				inherit font-family;
			})
		];

		wayland.windowManager.hyprland = {
			enable = true;
			systemd.enable = false;
			package = hyprland-pkgs.hyprland;
			portalPackage = hyprland-pkgs.xdg-desktop-portal-hyprland;
		};

		systemd.user.services.kanshi = {
			Unit = {
				Description = "Kanshi background service";
				BindsTo = [ "xdg-desktop-autostart.target" ];
			};

			Service = {
				Type = "simple";
				ExecCondition = "${pkgs.runtimeShell} -c '[ \"$XDG_SESSION_TYPE\" = wayland ]'";
				ExecStart = "${lib.getExe pkgs.kanshi} --config ${./kanshi.conf}";
			};

			Install = {
				WantedBy = [ "xdg-desktop-autostart.target" ];
			};
		};

	};
}
