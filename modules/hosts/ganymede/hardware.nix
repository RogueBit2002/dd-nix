{ inputs, ... }: {
	flake.nixosModules.ganymede-hardware = { ... }: {
		imports = [
			
			inputs.nixos-hardware.nixosModules.framework-16-7040-amd

			# Patches
			({ ... }: {
				fileSystems."/".options = [ "mode=755" ];
				fileSystems."/persist".neededForBoot = true;
				fileSystems."/var/log".neededForBoot = true;
			})

			# Generated hardware-configuration
			({ config, lib, pkgs, modulesPath, ... }: {
				imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

				boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod" ];
				boot.initrd.kernelModules = [ ];
				boot.kernelModules = [ "kvm-amd" ];
				boot.extraModulePackages = [ ];

				fileSystems."/" = {
					device = "tmpfs";
      				fsType = "tmpfs";
    			};

				fileSystems."/home" = {
					device = "/dev/mapper/crypt_system";
      				fsType = "btrfs";
      				options = [ "subvol=@home" ];
    			};

				boot.initrd.luks.devices."crypt_system".device = "/dev/disk/by-uuid/89c45253-8db1-44af-bd36-313b70f8084a";

				fileSystems."/nix" = {
					device = "/dev/mapper/crypt_system";
      				fsType = "btrfs";
      				options = [ "subvol=@nix" ];
    			};

  				fileSystems."/persist" = {
					device = "/dev/mapper/crypt_system";
      				fsType = "btrfs";
      				options = [ "subvol=@persist" ];
    			};

				fileSystems."/var/log" = {
					device = "/dev/mapper/crypt_system";
      				fsType = "btrfs";
    				options = [ "subvol=@log" ];
    			};

				fileSystems."/boot" = {
					device = "/dev/disk/by-uuid/FF7E-1FFC";
      				fsType = "vfat";
      				options = [ "fmask=0077" "dmask=0077" ];
    			};

				swapDevices = [ { device = "/dev/disk/by-partuuid/ca7a6f37-2298-4e64-94e4-e19fcc45b253"; randomEncryption.enable = true; }];

				nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  				hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
			})

		];
	};
}
