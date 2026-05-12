{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		
		import-tree.url = "github:vic/import-tree";
		
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
		
		nixos-hardware.url = "github:NixOS/nixos-hardware";

		nixos-wsl.url = "github:nix-community/NixOS-WSL?tag=2511.7.1";
		nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

		sops-nix.url = "github:Mic92/sops-nix";
  		sops-nix.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			systems = [ "x86_64-linux" ];
			imports = [
				(inputs.import-tree ../../modules)
				(inputs.import-tree ./modules)
			];
		};
}
