{ ... }: {
	flake.nixosModules.networking = { config, pkgs, lib, ... }: {	
		# Enable networkd
		systemd.network.enable = true;
		networking.useNetworkd = true;
		networking.useDHCP = true;
	
		
	};
}
