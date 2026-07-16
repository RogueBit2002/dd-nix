{ inputs, ... }: {
	flake.nixosModules.home-manager = { ... }: {
		imports = [ inputs.home-manager.nixosModules.default ];

		environment.pathsToLink = [
			"/share/applications" # home-manager
			"/share/xdg-desktop-portal" # home-manager
		];

		home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
		};
	};
}
