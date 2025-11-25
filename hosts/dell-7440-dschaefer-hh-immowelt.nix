# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { config.allowUnfree = true;};
in
{
  imports =
  [ # Include the results of the hardware scan.
    ./dell-7440-dschaefer-hh-immowelt-hardware-configuration.nix
  ];

  boot = {
    # https://wiki.archlinux.org/title/Intel_graphics
    #kernelParams = [ "i915.enable_psr=0" ];
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = {
      luksroot = {
        device= "/dev/nvme0n1p2";
        preLVM = true;
      };
    };
  };

  networking.hostName = "dell-7440-dschaefer-hh-immowelt"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.networkmanager.enable = true;

  # New office?
  networking.networkmanager.wifi.macAddress = "52:68:56:ac:59:0d";
  networking.networkmanager.wifi.scanRandMacAddress = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Enable sound.
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dschaefer = {
    isNormalUser = true;
    uid=1000;
    createHome = true;
    group = "users";
    extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    git
    qt5.qtwayland
    canon-cups-ufr2
    pulseaudio
  ];

  # https://github.com/adrienverge/openfortivpn/issues/1076#issuecomment-1777003887
  environment.etc."ppp/options".text = "ipcp-accept-remote";

  # If you are using Wayland you can choose to use the Ozone Wayland support in Chrome and several Electron apps by setting the environment variable NIXOS_OZONE_WL=1
  # https://github.com/NixOS/nixpkgs/blob/07dc8ecd7893b1b3b08b6b96ccd29e11b925fd23/nixos/doc/manual/release-notes/rl-2205.section.md?plain=1#L783-L789
  # https://discourse.nixos.org/t/default-command-line-args-for-the-brave-browser/21471
  # https://nixos.wiki/wiki/Slack
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.sway = {
    enable = true;
  };

  programs.bash.enableCompletion = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Needed for Yubikey
  services.pcscd.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
    logitech-udev-rules
  ];

  services.blueman.enable = true;

  #services.gnome.gnome-keyring.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    # 24.05
#    pipewire.wireplumber.extraConfig = {
#      bluetooth.autoswitch-to-headset-profile = true;
#    };
  };

  # Might fix the Sound issue with Firefox
  security.rtkit.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
  ];

  services.fwupd.enable = true;

  services.upower.enable = true;

  services.cloudflare-warp = {
    enable = true;
    package = unstable.cloudflare-warp;
    openFirewall = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Handy and needed
  # Without Firefox can't call the Slack app
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      # update to 24.05
      # https://github.com/NixOS/nixpkgs/pull/330787/files
      # gtkUsePortal = true;
    };
  };

  fileSystems = {
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
        "x-systemd.device-timeout=20s"
        "x-systemd.mount-timeout=20s"
      ];
    };
  };

  #####################################
  # Nix settings
  #####################################

  # Automatically run the garbage collector at a specific time.
  nix.gc.automatic = true;

  # Nix automatically detects files in the store that have
  # identical contents, and replaces them with hard links to a single copy.
  nix.settings.auto-optimise-store = true;

  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  # https://nixos.org/manual/nixos/stable/index.html#sec-upgrading-automatic
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
