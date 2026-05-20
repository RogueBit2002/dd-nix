{ self, inputs, ... }: {
	flake.homeModules.window-manager = {config, terminal, font-family, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;

		fuzzel = inputs.dd-apps.packages.${system}.fuzzel.override { inherit font-family; };
	in {
		imports = [
			inputs.dd-mtess.homeModules.default
		];

dconf.settings = {
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };
  };
/*dbus.packages = [ pkgs.dconf ];
*/
/*gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };*/
		programs.mtess = {
			enable = true;
			
			terminal = "${lib.getExe pkgs.app2unit} -- ${lib.getExe terminal}";
			launcher = "${lib.getExe fuzzel} --launch-prefix='${lib.getExe pkgs.app2unit} --'";
			clipboard = "${lib.getExe pkgs.cliphist} list | ${lib.getExe fuzzel} --dmenu | ${lib.getExe pkgs.cliphist} decode | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
			inherit font-family;
		};

		xdg.portal.enable = true;
		#xdg.portal.configPackages = [ pkgs.gnome-session ];
		home.packages = [
			pkgs.kanshi
			fuzzel
			pkgs.dconf # Required for gnome/gtk/dconf.settings
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
				ExecStart = "${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch ${lib.getExe pkgs.cliphist} store";
				Restart="on-failure";
			};

			Install = {
				WantedBy = [ "graphical-session.target" ];
			};

		};
	};
}
