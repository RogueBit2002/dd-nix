{ ... }: {
	flake.nixosModules.networking = { config, pkgs, lib, ... }: {	
		networking.networkmanager.enable = true;
	};
}
