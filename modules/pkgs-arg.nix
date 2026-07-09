({ inputs, ... }: {
	perSystem = { system, ... }: if builtins.hasAttr "nixpkgs" inputs then {
		_module.args.pkgs = import inputs.nixpkgs {
			inherit system;
			config.allowUnfree = true;
			config.permittedInsecurePackages = [
				"librewolf-152.0-1"
				"librewolf-unwrapped-152.0-1"
			];
		};
	} else {};
})
