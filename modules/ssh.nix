{ ... }: {
	flake.nixosModules.ssh = { ... }: { 	
		programs.ssh.startAgent = true;
	};

	flake.homeModules.ssh = { config, ... }: {
		programs.ssh = {
			enable = true;
			enableDefaultConfig = false;
		};
	};
}
