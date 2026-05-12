{
	description = "Stateful wayland session manager";
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		
		import-tree.url = "github:vic/import-tree";
		
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			imports = [
				(inputs.import-tree ../../modules)
				(inputs.import-tree ./modules)
			];

			systems = [ "x86_64-linux" ];
		};
}
