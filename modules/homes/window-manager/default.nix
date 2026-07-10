{ self, inputs, ... }: {
	flake.homeModules.window-manager = {config, terminal, font-family, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;

		cliphist = self.packages.${system}.cliphist;
	in {
		imports = [
			self.homeModules.mtess
		];

		dconf.settings = {
			"org/gnome/desktop/interface" = {
    			color-scheme = "prefer-dark";
  			};
  		};

		programs.mtess = {
			enable = true;
			
			terminal = "${lib.getExe pkgs.app2unit} -- ${lib.getExe terminal}";
			launcher = "${lib.getExe pkgs.fuzzel} --launch-prefix='${lib.getExe pkgs.app2unit} --'";
			clipboard = "${lib.getExe cliphist} list | ${lib.getExe pkgs.fuzzel} --dmenu | ${lib.getExe cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
			inherit font-family;
		};

		xdg.portal.enable = true;
		home.packages = [
			pkgs.fuzzel
			pkgs.kanshi
			pkgs.dconf # Required for gnome/gtk/dconf.settings
			pkgs.wl-clipboard
			cliphist
		];
	
			home.sessionVariables = {
				NIXOS_OZONE_WL = "1";
			};

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
				ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe cliphist} store";
				Restart="on-failure";
			};

			Install = {
				WantedBy = [ "graphical-session.target" ];
			};

		};
	};
}
