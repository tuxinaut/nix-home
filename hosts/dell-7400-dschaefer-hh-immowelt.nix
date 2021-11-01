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
#./virtualbox.nix
    ];

# https://github.com/NixOS/nixpkgs/pull/139807
#  nixpkgs.overlays = [(
#    self: super: {
#      canon-cups-ufr2 = super.canon-cups-ufr2.overrideAttrs (old: {
#        src = super.fetchurl {
#          url = "https://gdlp01.c-wss.com/gds/4/0100010264/01/linux-UFRII-drv-v370-uken-07.tar.gz";
#          sha256 = "01nxpg3h1c64p5skxv904fg5c4sblmif486vkij2v62wwn6l65pz";
#        };
#      });
#    }
#  )];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

boot.initrd.luks.devices =
{
luksroot = {
device= "/dev/nvme0n1p2";
preLVM = true;
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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
i18n.defaultLocale = "en_US.UTF-8";
console = {
font = "Lat2-Terminus16";
keyMap = "de";
};

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.printing.drivers = [
    pkgs.gutenprint
    pkgs.gutenprintBin
  ];
  # Automatically run the garbage collector at a specific time.
  nix.gc.automatic = true;

  # Nix automatically detects files in the store that have
  # identical contents, and replaces them with hard links to a single copy.
  nix.autoOptimiseStore = true;

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
    driSupport = true;
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
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
  services.blueman.enable = true;

#hardware.bluetooth.settings = {
#  general = "Enable=Source,Sink,Media,Socket";
#};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
users.users.dschaefer = {
isNormalUser = true;
uid=1000;
createHome = true;
group = "users";
extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" "vboxusers"]; # Enable ‘sudo’ for the user.
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
vim
git
qt5.qtwayland
  #networkmanagerapplet
  canon-cups-ufr2
  ];

services.udev.packages = with pkgs; [
  yubikey-personalization
  logitech-udev-rules
];

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

# Displays keypresses on screen on supported Wayland compositors (requires wlr_layer_shell_v1 support).
#
# https://git.sr.ht/~sircmpwn/wshowkeys
# Does not work because of errors
#programs.wshowkeys.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

# Needed for Yubikey
services.pcscd.enable = true;

services.pipewire.enable = true;
#services.pipewire.package = unstable.pipewire;

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
      #xdg-desktop-portal-gtk
    ];
    #gtkUsePortal = true;
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

  nixpkgs = {
    config.allowUnfree = true;
    config.allowBroken = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
