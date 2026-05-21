{ ... }: {
	flake.nixosModules.bluetooth = { config, pkgs, lib, ... }: {
		hardware.bluetooth.enable = true;
		
		# It's the default, but I still wanted to declare it
		hardware.bluetooth.package = pkgs.bluez;
	};
}
