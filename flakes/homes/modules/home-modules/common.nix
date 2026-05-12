{ self, inputs, ... }: {
	flake.homeModules.common = { config, lib, ... }: {
		
		programs.home-manager.enable = true;

		home.homeDirectory = lib.mkDefault "/home/${config.home.username}";
		home.stateVersion = "25.11";

		xdg.portal.enable = true;
		
		xdg.enable = true;
		xdg.userDirs = let
			docs = "${config.home.homeDirectory}/docs";
			misc = "${config.home.homeDirectory}/xdg-misc";
		in {
			enable = true;

			createDirectories = true;
			download = "${config.home.homeDirectory}/downloads";
			
			documents = docs;
			pictures = docs;
			videos = docs;
			music = docs;

			desktop = "${misc}/desktop";
			templates = "${misc}/templates";
			publicShare = "${misc}/public";
		};
	};
}
