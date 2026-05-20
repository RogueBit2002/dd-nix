{ ... }: {
	flake.nixosModules.networking = { config, pkgs, lib, ... }: {	
		# Enable networkd
		systemd.network.enable = true;
		networking.useNetworkd = true;
		networking.useDHCP = true;
	
		# disable wpa_supplicant, enable iwd
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

		# Nice tui for wifi
		environment.systemPackages = [
			pkgs.impala
		];
	};
}
