{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware

			self.nixosModules.common
			self.nixosModules.common-native
			
			self.nixosModules.user-definitions
			self.nixosModules.user-authentication_debug

			self.nixosModules.networking
			({ pkgs, ... }: {
				networking.hostName = "pandora";


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

				powerManagement.cpuFreqGovernor = "performance";

				programs.nix-ld.enable = true;
			})
		];
	};
}
