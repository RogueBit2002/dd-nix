{ self, inputs, ... }: {
	flake.homeModules.browser = { config, pkgs, lib, ... }: {
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
