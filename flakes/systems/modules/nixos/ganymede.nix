{ self, inputs, ... }: {
	flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.ganymede-hardware

			self.nixosModules.common
			self.nixosModules.common-native
			
			self.nixosModules.user-definitions
			self.nixosModules.user-authentication_debug
			
			self.nixosModules.networking
			self.nixosModules.wireless

			self.nixosModules.bluetooth

			({ pkgs, ... }: {
				networking.hostName = "ganymede";


				programs.ssh.startAgent = true;
				programs.steam = {
					enable = true;
					extraPackages = [ pkgs.gamescope ];
				};

				services.dbus.implementation = "broker";
			})
		];
	};
}
