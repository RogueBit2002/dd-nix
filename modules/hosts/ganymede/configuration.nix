{ self, inputs, ... }: {
	flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.ganymede-hardware	
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
	
				networking.hostName = "ganymede";
				
				
				services.fwupd.enable = true;


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

		hardware.bluetooth.enable = true;
		hardware.bluetooth.package = pkgs.bluez;

		networking.wireless.enable = false;
		networking.wireless.iwd = {
			enable = true;
			settings = {
				Network = {
					EnableIPv6 = true;
				};

				Settings = {
					AutoConnect = true;
				};
			};
		};
	
		home-manager = {
			users.roguebit = { ... }: {
				imports = [
					self.homeModules.window-manager
					self.homeModules.graphical
				];

				home.packages = with pkgs; [
					impala
				];

				home.stateVersion = "26.05";
			};
		};
		})
		];
	};
}
