{ ... }: {
	perSystem = { config, pkgs, lib, ... }: {
		packages.default = config.packages.xair;
		packages.xair = let
			scopify = pkgs.writeShellApplication {
				name = "xair-scopify";
				text = builtins.readFile ./scripts/scopify.sh;
			};

			app = pkgs.writeShellApplication {
				name = "xair-app";
				runtimeInputs = [ scopify ];
				text = builtins.readFile ./scripts/app.sh;
			};

		in pkgs.symlinkJoin {
			name = "xair";
			paths = [ scopify app ];
		};
	};
}
