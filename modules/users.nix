{ ... }: {
	flake.nixosModules.users = { ... }: {
		users.mutableUsers = false;
		users.users.roguebit = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
			password = "hello";
			uid = 1000;
		};

		users.users.root.password = "hello";	
	};

}
