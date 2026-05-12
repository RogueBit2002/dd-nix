{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		
		import-tree.url = "github:vic/import-tree";
		
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		home-manager.url = "github:nix-community/home-manager/release-25.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		hyprland.url = "github:hyprwm/Hyprland?tag=v0.55.0";
		
		dd-systems.url = "path:../systems";
		dd-desktop-shell.url = "path:../desktop-shell";
		dd-apps.url = "path:../apps";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			
			systems = [ "x86_64-linux" ];
			imports = [
				inputs.home-manager.flakeModules.home-manager

				(inputs.import-tree ../../modules)
				(inputs.import-tree ./modules)
			];
		};
}
