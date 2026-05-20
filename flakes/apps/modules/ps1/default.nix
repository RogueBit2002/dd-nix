{ ... }: {
	perSystem = { config, pkgs, lib, ... }: {
		packages.default = pkgs.writeShellApplication {
			text = ''
printf "$(echo hi)"
'';
		};
	};
}
