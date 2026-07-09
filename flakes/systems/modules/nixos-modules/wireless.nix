{ ... }: {
	flake.nixosModules.wireless = { ... }: {
		
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
	};
}
