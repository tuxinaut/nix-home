{ config, pkgs, ... }:

{
  # TODO
  # Link documentation explain?¿
  imports = [ <home-manager/nix-darwin> ];

  #nixpkgs.overlays = [ (import ./overlays/yabai) ];

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
  # https://github.com/LnL7/nix-darwin/wiki/Changing-the-configuration.nix-location
  environment.darwinConfig = "/etc/nixos/darwin-configuration.nix";

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
      ctrl + shift - return : /Applications/Hyper.app/Contents/MacOS/Hyper
      ctrl + cmd - a  : yabai -m space --focus next
      ctrl + cmd - s  : yabai -m space --focus prev
      ctrl + cmd - r  : yabai -m space --rotate 90
      ctrl + shift - x  : yabai -m display --focus last
      ctrl + shift - h  : yabai -m display --focus prev || yabai -m display --focus last
      ctrl + shift - l  : yabai -m display --focus next || yabai -m display --focus first
      ctrl + shift - 1  : yabai -m display --focus 1
      ctrl + shift - 2  : yabai -m display --focus 2
      ctrl + shift - 3  : yabai -m display --focus 3
      ctrl - a  : yabai -m window --focus prev
      ctrl - s  : yabai -m window --focus next
      ctrl + shift - a : yabai -m window --space prev || yabai -m window --space last
      ctrl + shift - s : yabai -m window --space next || yabai -m window --space first
      ctrl + shift - q : $(yabai -m window \$(yabai -m query --windows --window | jq -re \".id\") --close)
      ctrl + shift - n : yabai -m window --toggle native-fullscreen
      ctrl + shift - f : yabai -m window --toggle zoom-fullscreen
      ctrl + shift - m : yabai -m window --focus recent
      ctrl + cmd - h : /Users/dschaefer/bin/move-window-left-or-right-and-follow-focus \"prev\" \"last\"
      ctrl + cmd - l : /Users/dschaefer/bin/move-window-left-or-right-and-follow-focus \"next\" \"first\" ";
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = false; # https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
    config = {
      focus_follows_mouse        = "autoraise";
      mouse_follows_focus        = "on";
      window_placement           = "second_child";
      window_opacity             = "off";
      window_opacity_duration    = "0.0";
      window_topmost             = "on";
      window_shadow              = "float";
      active_window_opacity      = "1.0";
      normal_window_opacity      = "1.0";
      split_ratio                = "0.50";
      auto_balance               = "on";
      mouse_modifier             = "fn";
      mouse_action1              = "move";
      mouse_action2              = "resize";
      layout                     = "bsp";
      top_padding                = 5;
      bottom_padding             = 5;
      left_padding               = 5;
      right_padding              = 5;
      window_gap                 = 5;
      window_border              = "on"; # https://github.com/koekeishiya/yabai/issues/565
      window_border_width        = 6;
      active_window_border_color = "0xFF40FF00";
      normal_window_border_color = "0x00FFFFFF";
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

        #killall limelight &> /dev/null
        #limelight --config ~/.config/limelight/limelightrc &> /dev/null &
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