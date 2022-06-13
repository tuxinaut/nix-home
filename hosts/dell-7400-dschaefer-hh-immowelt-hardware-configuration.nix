# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "v4l2loopback" ];
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ]; # needed for virtual camera

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a573776c-c5a5-487a-b3d0-af991b9519bf";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B18C-BD10";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/03e802b1-145f-404e-a4b2-71724058147f"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
