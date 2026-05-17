{ self, inputs, ... }: {
	flake.homeModules.default = { config, pkgs, lib, ... }: let
		system = pkgs.stdenv.hostPlatform.system;
		cfg = config.programs.mtess;
	in {
		options.programs.mtess = {
			enable = lib.mkEnableOption "Enabled MTess";

			label = lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				default = null;
			};

			terminal = lib.mkOption {
				type = lib.types.package;
				default = pkgs.kitty;
			};

			font-family = lib.mkOption {
				type = lib.types.nullOr lib.types.str;
				default = null;
			};

			hooks = lib.mkOption {
				type = lib.types.listOf lib.types.str;
				default = [];
			};
		};

		config = lib.mkIf cfg.enable {
			home.packages = [
				pkgs.uwsm
				(self.packages.${system}.default.override { 
					label = cfg.label;
					terminal = cfg.terminal;
					font-family = cfg.font-family;
					hooks = cfg.hooks;
					uwsm = pkgs.uwsm;
				})
			];

			xdg.portal = {
				extraPortals = [ inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk ];

				config.MTess = {
					default = [ "hyprland" "gtk" ];
				};
			};
			
		};
	};
}
