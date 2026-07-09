{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware	
			self.nixosModules.nix
			self.nixosModules.graphics-amd
			self.nixosModules.users

			self.nixosModules.ssh
			self.nixosModules.compat

			self.nixosModules.gaming
			self.nixosModules.common

			({ pkgs, lib, ... }: {
				system.stateVersion = "25.11";
	
				services.dbus.implementation = "broker";
				
				services.fwupd.enable = true;

				powerManagement.cpuFreqGovernor = "performance";

				systemd.network.enable = true;
				networking.useNetworkd = true;
				networking.useDHCP = true;
			})
		];
	};
}
