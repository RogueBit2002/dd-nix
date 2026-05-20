{ self, inputs, withSystem, ... }: {
	flake.homeConfigurations."roguebit@ganymede" = let 
		system = inputs.dd-systems.nixosConfigurations.ganymede.pkgs.stdenv.hostPlatform.system;
		pkgs = withSystem system ({ pkgs, ... }: pkgs);

	in inputs.home-manager.lib.homeManagerConfiguration {
		inherit pkgs;

		extraSpecialArgs = rec {
			font-family = "0xProto";
			terminal = inputs.dd-apps.packages.${system}.kitty.override { inherit font-family; };
		};

		modules = [
			self.homeModules.common
			self.homeModules.essentials
			self.homeModules.window-manager
			self.homeModules.browser

			({ config, terminal, pkgs, lib, ... }: {
				home.username = "roguebit";
				
				fonts.fontconfig.enable = true;
				home.packages = with pkgs; [
					_0xproto
					unityhub
				] ++ (with inputs.dd-apps.packages.${system}; [
					nvim
					yazi
					wiremix
				]) ++ [
					terminal
				];

				home.sessionVariables = {
					EDITOR = "nvim";
					TERMINAL = "${lib.getExe terminal}";
					NIXOS_OZONE_WL = "1";
				};
		
				programs.bash = {
					enable = true;
				};

				programs.discord.enable = true;

				programs.ssh = {
					enable = true;
					enableDefaultConfig = false;
					matchBlocks."github.com" = {
						hostname = "github.com";
						user = "git";
						identityFile = "${config.home.homeDirectory}/.ssh/github_ed25519";
					};
				};
			})
		];
	};
}
