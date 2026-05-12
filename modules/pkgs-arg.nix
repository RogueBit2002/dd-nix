({ inputs, ... }: {
	perSystem = { system, ... }: if builtins.hasAttr "nixpkgs" inputs then {
		_module.args.pkgs = import inputs.nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
	} else {};
})
