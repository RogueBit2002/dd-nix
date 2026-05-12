{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware

			self.nixosModules.common
			self.nixosModules.common-native
			
			self.nixosModules.user-definitions
			self.nixosModules.user-authentication_debug

			({ pkgs, ... }: {
				networking.hostName = "pandora";

				networking.networkmanager.enable = true;

				programs.ssh.startAgent = true;
				programs.steam = {
					enable = true;
					extraPackages = [ pkgs.gamescope ];
				};

				services.dbus.implementation = "broker";

				hardware.graphics = {
					enable = true;
					enable32Bit = true;
				};

				services.fwupd.enable = true;
				boot.kernelPackages = pkgs.linuxPackages_6_18;
			})
		];
	};
}
