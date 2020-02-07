# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./nixos-hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/nvme0n1p2";
      preLVM = true;

    }
  ];

  boot.kernelParams = [ "modeset=1" "i915.enable_fbc=1" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    networkmanager = {
      enable = true;
    };
  };


  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    htop
    linuxPackages.exfat-nofuse
    fwupd
    fwupdate
  ];

  services.udev.packages = with pkgs; [
    yubikey-personalization
    autorandr
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.qt5ct.enable = true;

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
      device = "//nas.tuxinaut.de/Daten";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
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
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
      ];
    };
    "/storage/Photo" = {
      device = "//nas.tuxinaut.de/Photo";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
      ];
    };
    "/storage/Robocopy" = {
      device = "//nas.tuxinaut.de/Robocopy";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
      ];
    };
    "/storage/Sicherungen" = {
      device = "//nas.tuxinaut.de/Sicherungen";
      fsType = "cifs";
      noCheck = true;
      options = [
        "user"
        "uid=1000"
        "gid=1000"
        "credentials=/etc/nas"
        "nofail"
        "x-systemd.automount"
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
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
        "x-systemd.device-timeout=2s"
        "x-systemd.mount-timeout=2s"
      ];
    };
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Update the CPU microcode for Intel processors.
  hardware.cpu.intel.updateMicrocode = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = ''
      load-module module-switch-on-connect
    '';
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.extraConfig = "
    [General]
    Enable=Source,Sink,Media,Socket
  ";

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  # needed to support 32Bit games
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.acpilight.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  # services.xserver.xkbOptions = "eurosign:e";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.autorun = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.autorandr.enable = true;
  services.keybase.enable = true;
  services.kbfs.enable = true;
  services.teamviewer.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
    programs.adb.enable = true;

  users.extraUsers.tuxinaut = {
    createHome = true;
    extraGroups = ["adbusers" "wheel" "video" "audio" "disk" "networkmanager"];
    group = "users";
    home = "/home/tuxinaut";
    isNormalUser = true;
    uid = 1000;
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
