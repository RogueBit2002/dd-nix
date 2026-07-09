{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";

		import-tree.url = "github:vic/import-tree";

		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		
		home-manager.url = "github:nix-community/home-manager/release-26.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		hyprland.url = "github:hyprwm/Hyprland?tag=v0.55.0";
		
		fsel.url = "github:Mjoyufull/fsel?tag=3.4.1";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			imports = [
				inputs.home-manager.flakeModules.home-manager

				(inputs.import-tree ../../modules)	
				(inputs.import-tree ./modules)
			];

			systems = [ "x86_64-linux" ];
		};


}
