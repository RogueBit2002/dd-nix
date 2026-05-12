{ self, withSystem, ... }: {
	flake.nixosModules.common = { pkgs, lib, config, ... }: {
		nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs );

		nix.settings.experimental-features = [ "nix-command" "flakes" ];

		system.stateVersion = "25.11";

		users.mutableUsers = false;

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

		security.polkit.enable = true;

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

		
	};
}
