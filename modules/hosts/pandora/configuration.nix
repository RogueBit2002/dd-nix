{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware	

			inputs.impermanence.nixosModules.impermancence

			self.nixosModules.nix
			self.nixosModules.graphics-amd
			self.nixosModules.users

			self.nixosModules.ssh
			self.nixosModules.compat

			({ pkgs, lib, ... }: {
				system.stateVersion = "26.05";
	
				services.dbus.implementation = "broker";
				
				services.fwupd.enable = true;

				powerManagement.cpuFreqGovernor = "performance";

				environment.persistence."/persist" = {
					enable = true;

					directories = [
						"/var/lib"
					];

					files = [
						"/etc/machine-id"
					];
				};


				systemd.network.enable = true;
				networking.useNetworkd = true;
				networking.useDHCP = true;
	
	environment.systemPackages = with pkgs; [
			wget
			dig
			git
			git-credential-manager
			age
			sops
			unzip
			lm_sensors
		];
		
		boot.kernelPackages = lib.mkForce pkgs.linuxPackages_7_0;
		boot.loader.systemd-boot.enable = true;
 		boot.loader.efi.canTouchEfiVariables = true;

		services.greetd = {
			enable = true;
			useTextGreeter = true;
			settings = {
				default_session = {
					command = "${lib.getExe pkgs.tuigreet} --remember --remember-user-session --time";
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

		time.timeZone = "Europe/Amsterdam";

		i18n.defaultLocale = "en_US.UTF-8";
		i18n.extraLocaleSettings = {
			LC_ADDRESS = "nl_NL.UTF-8";
			LC_IDENTIFICATION = "nl_NL.UTF-8";
			LC_MEASUREMENT = "nl_NL.UTF-8";
			LC_MONETARY = "nl_NL.UTF-8";
			LC_NAME = "nl_NL.UTF-8";
			LC_NUMERIC = "nl_NL.UTF-8";
			LC_PAPER = "nl_NL.UTF-8";
			LC_TELEPHONE = "nl_NL.UTF-8";
			LC_TIME = "nl_NL.UTF-8";
		};
		})
		];
	};
}
