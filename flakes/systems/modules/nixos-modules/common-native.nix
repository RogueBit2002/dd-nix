{ ... }: {
	flake.nixosModules.common-native = { pkgs, lib, ... }: {
		# boot.kernelPackages = lib.mkForce pkgs.linuxPackages_7_0;
		boot.loader.systemd-boot.enable = true;
 		boot.loader.efi.canTouchEfiVariables = true;

		services.greetd = {
			enable = true;
			useTextGreeter = true;
			settings = {
				default_session = {
					command = "${lib.getExe pkgs.tuigreet} --remember --time";
        			user = "greeter";
				};
			};
		};

		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
}
