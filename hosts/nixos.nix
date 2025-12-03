# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in

{
  imports =
    [
      <nixos-hardware/dell/xps/13-9360> # https://github.com/NixOS/nixos-hardware
      ./nixos-hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;

    };
  };

  boot.kernelParams = [ "modeset=1" ];

  # Whether to delete all files in /tmp during boot.
  boot.tmp.cleanOnBoot = true;

  networking = {
    networkmanager = {
      enable = true;
    };
  };


  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    htop
    #linuxPackages.exfat-nofuse
    firmwareLinuxNonfree
    fwupd
    canon-cups-ufr2
    cups-filters
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
    #LIBGL_DRI3_DISABLE = 1; # https://wiki.archlinux.org/title/Intel_graphics#DRI3_issues
  };

  # Enable virtualbox.
  virtualisation = {
    docker = {
      enable = true;
    };
    virtualbox = {
      host = {
        package = pkgs.virtualbox;
        enable = true;
        enableExtensionPack = true;
      };
    };
  };

  services.udev.packages = with pkgs; [
    yubikey-personalization
    autorandr
    virtualbox
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.completion.enable = true;

  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  qt.platformTheme = "qt5ct";

  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };

  # List services that you want to enable:

  # Needed for Yubikey
  services.pcscd.enable = true;

  services.fwupd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  fileSystems = {
    "/storage/Daten" = {
      device = "//nas.tuxinaut.de/data";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/Music" = {
      device = "//nas.tuxinaut.de/Music";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/Photo" = {
      device = "//nas.tuxinaut.de/photo";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/Sicherungen" = {
      device = "//nas.tuxinaut.de/backups";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/docker" = {
      device = "//nas.tuxinaut.de/docker";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas-admin"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/documents" = {
      device = "//nas.tuxinaut.de/documents";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/homes" = {
      device = "//nas.tuxinaut.de/homes";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/home/tuxinaut/.nas-root"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
    "/storage/Video" = {
      device = "//nas.tuxinaut.de/Video";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.mount-timeout=5s"
        "_netdev"
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
  ];

  # Enable SANE for scanning
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  # Update the CPU microcode for Intel processors.
  hardware.cpu.intel.updateMicrocode = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };


    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
    };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  hardware.acpilight.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.autorun = true;

  # Double check if that here really helps
  # https://www.youtube.com/watch?v=9hIRq5HTh5s
  services.xserver.videoDrivers = [ "modesetting" ];

# Not working with 24.11 anymore
# Youtube performace with 2x is horrible :|
# https://github.com/NixOS/nixpkgs/pull/365448/files#diff-a9dc66a79341a1e27acaee259a4f5c9e8bc6b2386b701b93b4e071dcae80a2c4
#  services.xserver.videoDrivers = [ "intel" ];
#services.xserver.deviceSection = ''
#  Option "TearFree" "true"
#  Option "DRI" "3" → Old firefox crashes
#'';

  # Enable touchpad support.
  services.libinput.enable = true;

  services.xserver.exportConfiguration = true;

  services.autorandr.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.adb.enable = true;

  users.extraUsers.tuxinaut = {
    createHome = true;
    extraGroups = ["adbusers" "docker" "dialout" "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" "scanner" "lp" "avahi"];
    group = "users";
    home = "/home/tuxinaut";
    isNormalUser = true;
    uid = 1000;
  };

  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;

    # https://nixos.wiki/wiki/Accelerated_Video_Playback
    config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?
}
