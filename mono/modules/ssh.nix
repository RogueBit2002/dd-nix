{ ... }: {
	flake.nixosModules.ssh = { ... }: { 	
		programs.ssh.startAgent = true;
	};

	flake.homeModules.ssh = { config, ... }: {
		programs.ssh = {
			enable = true;
			enableDefaultConfig = false;
			settings."github.com" = {
				hostname = "github.com";
				user = "git";
				identityFile = "${config.home.homeDirectory}/.ssh/github_ed25519";
			};
		};
	};
}
