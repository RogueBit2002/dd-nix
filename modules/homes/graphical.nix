{ self, inputs, ... }: {
	flake.homeModules.graphical = { pkgs, lib, config, ... }: let
		system = pkgs.stdenv.hostPlatform.system;
	in {
		_module.args = {
			font-family = "0xProto";
			terminal = config.programs.kitty.package;
		};

		imports = [
			self.homeModules.minimal
		];


		fonts.fontconfig.enable = true;
		home.packages = with pkgs; [
			_0xproto
		];


		programs.kitty.enable = true;
		programs.kitty.package = self.packages.${system}.kitty; 

		programs.librewolf = {
			enable = true;
			settings = {
				"webgl.disabled" = false;
				"privacy.resistFingerprinting" = false;
				"sidebar.visibility" = "always-show";
				"sidebar.verticalTabs" = true;
				"sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
			};	
		};
		

	};
}
