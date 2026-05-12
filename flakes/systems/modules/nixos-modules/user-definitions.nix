{ self, inputs, ... }: {
	flake.nixosModules.user-definitions = { ... }: {
		users.users.roguebit = {
			isNormalUser = true;
			extraGroups = [ "wheel" ];
		};
	};
}
