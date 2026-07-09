{ ... }: {
	flake.nixosModules.users = { ... }: let
		password-hash = "$y$j9T$CDDZhg4BoZ5xjPiWqXZzW/$XR/Sj90HtTeoEK/.AiCwv3OpMEmRdf/n6qsDBNWa2h6";
	in {
		users.mutableUsers = false;
		users.users.roguebit = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			hashedPassword = password-hash;
		};

		users.users.root.hashedPassword = password-hash;	
	};

}
