{ self, inputs, ... }: {
	flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.ganymede-hardware
			
			self.nixosModules.users
			
			({ pkgs, ... }: {
				networking.hostName = "ganymede";
	
				system.stateVersion = "25.11";

				services.dbus.implementation = "broker";
			})
		];
	};
}
