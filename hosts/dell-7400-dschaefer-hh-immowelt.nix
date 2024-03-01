# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in
{
  imports =
  [ # Include the results of the hardware scan.
    ./dell-7400-dschaefer-hh-immowelt-hardware-configuration.nix
  ];

  # https://github.com/NixOS/nixpkgs/pull/139807
#  nixpkgs.overlays = [(
#    self: super:
#{
#  ppp = super.ppp.overrideAttrs (old: {
#    version = "2.4.9";
#    sha256 = "sha256-8+nbqRNfKPLDx+wmuKSkv+BSeG72hKJI4dNqypqeEK4=";
#    configureFlags = [
#      "--with-openssl=${super.openssl.dev}"
#    ];
#  });
#}

  #    self: super: {
  #      canon-cups-ufr2 = super.canon-cups-ufr2.overrideAttrs (old: {
  #        src = super.fetchurl {
  #          url = "https://gdlp01.c-wss.com/gds/4/0100010264/01/linux-UFRII-drv-v370-uken-07.tar.gz";
  #          sha256 = "01nxpg3h1c64p5skxv904fg5c4sblmif486vkij2v62wwn6l65pz";
  #        };
  #      });
  #    }
 #   )];

  boot = {
    # https://wiki.archlinux.org/title/Intel_graphics
    kernelParams = [ "i915.enable_psr=0" ];
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

  networking.hostName = "dell-7400-dschaefer-hh-immowelt"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;

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
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;

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

  services.pipewire = {
    enable = true;
    pulse.enable = true;

    media-session.config.bluez-monitor.rules = [
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
  ];

  services.fwupd.enable = true;

  services.upower.enable = true;

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
      ];
    };
  };

  fileSystems = {
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
  system.stateVersion = "20.09"; # Did you read the comment?
}
