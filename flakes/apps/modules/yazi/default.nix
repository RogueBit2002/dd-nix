{ ... }: {
	perSystem = { pkgs, ... }: {
		packages.yazi = pkgs.yazi;
	};
}
