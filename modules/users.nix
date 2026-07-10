{ ... }: {
	flake.nixosModules.users = { config, ... }: {
		
		sops.secrets."roguebit/hashedPassword".neededForUsers = true;

		users.mutableUsers = false;
		users.users.roguebit = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			hashedPasswordFile = config.sops.secrets."roguebit/hashedPassword".path;
			uid = 1000;
		};

		# users.users.root.password = "hello";	
	};

}
