{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware	
			self.nixosModules.common

			inputs.impermanence.nixosModules.impermanence
			self.nixosModules.home-manager

			self.nixosModules.sops
			self.nixosModules.nix
			self.nixosModules.graphics-amd
			self.nixosModules.users

			self.nixosModules.compat

			({ pkgs, lib, ... }: {
				system.stateVersion = "26.05";
	
				networking.hostName = "pandora";
				
				
				services.fwupd.enable = true;

				powerManagement.cpuFreqGovernor = "performance";

				environment.persistence."/persist" = {
					enable = true;

					directories = [
						"/var/lib"
					];

					files = [
						"/etc/machine-id"
						"/etc/ssh/ssh_host_ed25519_key"
						"/etc/ssh/ssh_host_ed25519_key.pub"
					];
				};
				

				systemd.network.enable = true;
				networking.useNetworkd = true;
				networking.useDHCP = true;

		
		programs.steam.enable = true;


		home-manager.users.roguebit = { ... }: {
				imports = [
					self.homeModules.window-manager
					self.homeModules.graphical
				];


				home.stateVersion = "26.05";
		};
		})
		];
	};
}
