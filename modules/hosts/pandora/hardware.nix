{ inputs, ... }: {

	flake.nixosModules.pandora-hardware = { ... }: {
		imports = [
			inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
     		
			# Patches
			({ ... }: {
				fileSystems."/".options = [ "mode=755" ];
				fileSystems."/var/log".neededForBoot = true;
				fileSystems."/persist".neededForBoot = true;
			})

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

				fileSystems."/boot" = {
					device = "/dev/disk/by-uuid/2709-8798";
      				fsType = "vfat";
      				options = [ "fmask=0077" "dmask=0077" ];
    			};

				fileSystems."/home" = {
					device = "/dev/mapper/crypt_system";
					fsType = "btrfs";
      				options = [ "subvol=@home" ];
				};

				boot.initrd.luks.devices."crypt_system".device = "/dev/disk/by-uuid/11f3b822-ef83-41b3-8d30-1d23a9d1d84e";

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

				fileSystems."/nix" = {
					device = "/dev/mapper/crypt_system";
      				fsType = "btrfs";
      				options = [ "subvol=@nix" ];
				};

				swapDevices = [ { device = "/dev/disk/by-partuuid/aecfac07-85fa-4037-a44c-0dd9ab134c21"; randomEncryption.enable = true; } ];

				nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
				hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
			})

    ];
  };
}
