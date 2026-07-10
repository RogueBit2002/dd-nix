{ self, inputs, ... }: {
	flake.homeModules.minimal = { pkgs, lib, config, ... }: let
		system = pkgs.stdenv.hostPlatform.system;
	in {
		
		programs.ssh = {
			enable = true;
			enableDefaultConfig = false;
		};

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
		
		programs.zoxide = {
			enable = true;

			enableBashIntegration = true;
			enableFishIntegration = true;
			enableNushellIntegration = true;
			enableZshIntegration = true;

			options = [
				"--cmd cd"
			];
		};

		programs.bash.enable = true;

		programs.tmux.enable = true;

		programs.neovim.enable = true;
		programs.neovim.package = self.packages.${system}.neovim;
		programs.neovim.defaultEditor = true;

		programs.yazi.enable = true;
		programs.yazi.enableBashIntegration = true;	
	};
}
