{ config, pkgs, ... }:

{
  # TODO
  # Link documentation explain?¿
  imports = [ <home-manager/nix-darwin> ];

  # Changing the configuration.nix location
  # https://github.com/LnL7/nix-darwin/wiki/Changing-the-configuration.nix-location
  environment.darwinConfig = "/etc/nixos/darwin-configuration.nix";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.skhd
      pkgs.jq
      pkgs.bashInteractive_5
      #pkgs.bash # install bash4 because default under macOS is 3, but it will still start with version 3
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true; # This only works with bash version 4 https://github.com/LnL7/nix-darwin/blob/master/modules/programs/bash/default.nix
  };

  system.defaults.dock.autohide = true;
  system.defaults.dock.mru-spaces = false;
  system.defaults.dock.orientation = "left";
  system.defaults.dock.showhidden = true;

  services.skhd = {
    enable = true;
    skhdConfig =
      "ctrl + alt + cmd - r : launchctl kickstart -k \"gui/\${UID}/homebrew.mxcl.yabai\"
      ctrl + shift - f : yabai -m window --toggle zoom-fullscreen
      ctrl - a  : yabai -m window --focus prev
      ctrl - s  : yabai -m window --focus next
      ctrl + shift - a : yabai -m window --space prev
      ctrl + shift - s : yabai -m window --space next
      ctrl + shift - return : /Applications/Hyper.app/Contents/MacOS/Hyper
      ctrl + shift - q : $(yabai -m window \$(yabai -m query --windows --window | jq -re \".id\") --close)
      ctrl + shift - n : yabai -m window --toggle native-fullscreen
      ctrl + shift - z : yabai -m window --toggle zoom-fullscreen";
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false; # false Stop flicking of the menubar!
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "on";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 10;
      bottom_padding               = 2;
      left_padding                 = 2;
      right_padding                = 2;
      window_gap                   = 2;
    };

    extraConfig = ''
        # rules
        yabai -m rule --add app='System Preferences' manage=on

        # Any other arbitrary config here

        # My custom space names for my 3 monitor setup. These names are used in some of my scripts.
        yabai -m space 1 --label one
        yabai -m space 2 --label two
        yabai -m space 3 --label three
        yabai -m space 4 --label four
        yabai -m space 5 --label five
        yabai -m space 6 --label six
        yabai -m space 9 --label nine

        killall limelight &> /dev/null
        limelight --config ~/.config/limelight/limelightrc &> /dev/null &
      '';
    };

    fonts.enableFontDir = true;
    fonts.fonts = [
      pkgs.powerline-fonts
    ];


  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # TODO
  # Link documentation explatin why
  # users.$USER entry lets home-manger run when nix-darwin runs!
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.dschaefer = ./home.nix;
  };
}
