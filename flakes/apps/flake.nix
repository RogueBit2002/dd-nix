{
	inputs = {
		flake-parts.url = "github:hercules-ci/flake-parts";
		
		import-tree.url = "github:vic/import-tree";
		
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
		
		pancake.url = "github:RogueBit2002/pancake.nvim";
	};

	outputs = { ... }@inputs: inputs.flake-parts.lib.mkFlake
		{ inherit inputs; }
		{
			imports = [
				(inputs.import-tree ../../modules)
				(inputs.import-tree ./modules)
			];

			systems = [
				"x86_64-linux"
			];
		};
}
