{ self, inputs, ... }: {
	flake.homeModules.window-manager = { terminal, font-family, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;
	in {


		imports = [
			inputs.dd-mtess.homeModules.default
		];

		programs.mtess = {
			enable = true;
			inherit terminal;
			inherit font-family;
		};

		xdg.portal.enable = true;

		home.packages = [
			pkgs.kanshi
		];
		
		systemd.user.services.kanshi = {
			Unit = {
				Description = "Kanshi background service";
				BindsTo = [ "graphical-session.target" ];
				After = [ "graphical-session.target" ];
			};

			Service = {
				Type = "simple";
				ExecEnvironment = "XDG_SESSION_TYPE=wayland";
				ExecStart = "${lib.getExe pkgs.kanshi} --config ${./kanshi.conf}";
				Restart="on-failure";
			};

			Install = {
				WantedBy = [ "graphical-session.target" ];
			};
		};
		
		systemd.user.services.wayland-wallpaper = {
			Unit = {
				Description = "Wallpaper background service";
				BindsTo = [ "graphical-session.target" ];
				After = [ "graphical-session.target" ];
			};

			Service = {
				Type = "simple";
				ExecEnvironment = "XDG_SESSION_TYPE=wayland";
				ExecStart = "${lib.getExe pkgs.swaybg} --image ${self + /resources/wallpapers/fw-ascii-hand.png} --mode fit --color 000000";
				Restart="on-failure";
			};

			Install = {
				WantedBy = [ "graphical-session.target" ];
			};
		};
	};
}
