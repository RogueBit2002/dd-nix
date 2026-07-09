{ inputs, ... }: {

	flake.nixosModules.pandora-hardware = { ... }: {
		imports = [
			inputs.nixos-hardware.nixosModules.framework-desktop-amd-ai-max-300-series
      (
        {
          config,
          lib,
          pkgs,
          modulesPath,
          ...
        }:

        {
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
          ];

          boot.initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-amd" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/mapper/crypt_root";
            fsType = "btrfs";
            options = [ "subvol=@" ];
          };

          boot.initrd.luks.devices."crypt_root".device =
            "/dev/disk/by-uuid/a61399c1-0fa6-43ae-8964-6b5417f721e2";

          fileSystems."/home" = {
            device = "/dev/mapper/crypt_root";
            fsType = "btrfs";
            options = [ "subvol=@home" ];
          };

          fileSystems."/nix" = {
            device = "/dev/mapper/crypt_root";
            fsType = "btrfs";
            options = [ "subvol=@nix" ];
          };

          fileSystems."/persist" = {
            device = "/dev/mapper/crypt_root";
            fsType = "btrfs";
            options = [ "subvol=@persist" ];
            neededForBoot = true;
          };

          fileSystems."/var/log" = {
            device = "/dev/mapper/crypt_root";
            fsType = "btrfs";
            options = [ "subvol=@log" ];
            neededForBoot = true;
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/6EF4-B27F";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          swapDevices = [
            {
              device = "/dev/disk/by-partuuid/537dd5a3-5bd4-4d14-8a3e-18f10adedb60";
              randomEncryption.enable = true;
            }
          ];

          nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
          hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
        }
      )

    ];
  };
}
