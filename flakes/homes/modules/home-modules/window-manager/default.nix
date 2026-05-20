{ self, inputs, ... }: {
	flake.homeModules.window-manager = {config, terminal, font-family, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;

		fuzzel = inputs.dd-apps.packages.${system}.fuzzel.override { inherit font-family; };
	in {
		imports = [
			inputs.dd-mtess.homeModules.default
		];


		programs.mtess = {
			enable = true;
			
			terminal = "${lib.getExe pkgs.app2unit} -- ${lib.getExe terminal}";
			launcher = "${lib.getExe fuzzel} --launch-prefix='${lib.getExe pkgs.app2unit} --'";
			clipboard = "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy ";
			inherit font-family;
		};

		xdg.portal.enable = true;

		home.packages = [
			pkgs.kanshi
			pkgs.app2unit
			pkgs.wl-clipboard
			pkgs.cliphist
			fuzzel
			
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

		systemd.user.services.cliphist = {
			Unit = {
				Description = "Cliphist service";
				BindsTo = [ "graphical-session.target" ];
				After = [ "graphical-session.target" ];
			};

			Service = {
				Type = "simple";
				ExecEnvironment = "XDG_SESSION_TYPE=wayland";
				ExecStart = "wl-paste --watch cliphist store";
				Restart="on-failure";
			};

			Install = {
				WantedBy = [ "graphical-session.target" ];
			};

		};
	};
}
