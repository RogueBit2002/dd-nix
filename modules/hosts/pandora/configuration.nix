{ self, inputs, ... }: {
	flake.nixosConfigurations.pandora = inputs.nixpkgs.lib.nixosSystem {
		modules = [
			self.nixosModules.pandora-hardware	

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
				
				services.dbus.implementation = "broker";
				
				services.fwupd.enable = true;

				programs.ssh.startAgent = true;
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
				
				security.sudo.extraConfig = ''
					Defaults lecture = never
				'';



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
		
		boot.kernelPackages = lib.mkForce pkgs.linuxPackages_7_1;
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
