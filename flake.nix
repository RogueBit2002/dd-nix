{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		
		import-tree.url = "github:vic/import-tree";
		
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		
		nixos-hardware.url = "github:NixOS/nixos-hardware";

		impermanence.url = "github:nix-community/impermanence";
		impermanence.inputs.nixpkgs.follows = "nixpkgs";
		impermanence.inputs.home-manager.follows = "";

		home-manager.url = "github:nix-community/home-manager/release-26.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
		
		hyprland.url = "github:hyprwm/Hyprland?tag=v0.55.0";
		pancake.url = "github:RogueBit2002/pancake.nvim";

		sops-nix.url = "github:Mic92/sops-nix";
		sops-nix.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			systems = [ "x86_64-linux" ];
			imports = [
				({ inputs, ... }: {
					perSystem = { system, ... }: {
						_module.args.pkgs = import inputs.nixpkgs {
							inherit system;
							config.allowUnfree = true;
						};
					};
				})

				inputs.home-manager.flakeModules.home-manager

				(inputs.import-tree ./modules)
			];
		};
}
