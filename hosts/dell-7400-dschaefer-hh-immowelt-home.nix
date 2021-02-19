{ pkgs, lib, config, ... }:

let
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';

  vim-quick-scope = pkgs.vimUtils.buildVimPlugin {
    name = "quick-scope";
    src = pkgs.fetchFromGitHub {
      owner = "unblevable";
      repo = "quick-scope";
      rev= "994576d997a52b4c7828149e9f1325d1c4691ae2";
      sha256= "0lr27vwv2bzva9s7f9d856vvls10icwli0kwj5v5f1q8y83fa4zd";
    };

    buildInputs = [ pkgs.zip pkgs.vim ];
  };

  # See https://nixos.wiki/wiki/Vim
  my_vim_configurable = pkgs.vim_configurable.override {
    python = pkgs.python37Full;
  };

  my_vimPlugins = with pkgs.vimPlugins; [
    iceberg-vim
    Tabular
    vim-indent-guides
    syntastic
    fugitive
    nerdtree
    ctrlp
    #vim-gnupg
    vim-airline
    #SudoEdit.vim
    vim-multiple-cursors
    surround
    editorconfig-vim
    vim-better-whitespace
    #Dockerfile.vim
    #Vim-Jinja2-Syntax
    neocomplete
    neosnippet
    neosnippet-snippets
    vim-snippets
    vim-airline-themes
    molokai
    tagbar
    vim-quick-scope
  ];
    modifier = config.wayland.windowManager.sway.config.modifier;
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in

{
  home.packages = [
    pkgs.firefox-wayland
pkgs.bashCompletion
    # Unstable because of error regarding autocompletionn
    unstable.awscli2
    pkgs.git
    pkgs.htop
    pkgs.keepassxc
    pkgs.signal-desktop
    unstable.slack
    # Screensharing
    #pkgs.pipewire
    pkgs.pipewire_0_2
    pkgs.xdg-desktop-portal
    #pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
    pkgs.pavucontrol
    # Display management
    pkgs.wdisplays
    pkgs.wlr-randr
    pkgs.yubioath-desktop
    pkgs.hstr
    # https://github.com/altdesktop/playerctl
    pkgs.playerctl
    # fonts
    pkgs.font-awesome
    pkgs.powerline-fonts
      (
        my_vim_configurable.customize {
          name = "vim";
          vimrcConfig.packages.myVimPackage = {
            start = my_vimPlugins;
          };

          vimrcConfig.customRC = ''
            ${ (builtins.readFile ../vim/vimrc) }
          '';
        })
    # Needed for Immowelt SSO
    pkgs.python38Packages.virtualenv
    pkgs.phantomjs
    pkgs.chromedriver
    pkgs.google-chrome
    # Communication
    unstable.teams
    # Backlight
    pkgs.brightnessctl
  ];

wayland.windowManager.sway = {
  enable = true;
  package = unstable.sway;
  wrapperFeatures = {
    base = true;
    gtk = true;
  };
config = {
output = {
"*" = {
bg = "/etc/nixos/wallpaper.png fill";
};
};
fonts = [
"pango:monospace 9"
"FontAwesome 9"
];
modifier = "Mod4";
  keybindings =
    lib.mkOptionDefault {
"${modifier}+Tab" = "exec ${unstable.wofi}/bin/wofi -d --show run,drun";
"${modifier}+Shift+h" = "move workspace to output left";
"${modifier}+Shift+l" = "move workspace to output right";
"${modifier}+Shift+j" = "move workspace to output up";
"${modifier}+Shift+k" = "move workspace to output down";
"Control+${modifier}+q" = "workspace back_and_forth";
"${modifier}+1" = "workspace number 1";
# Backlight
# needs brightnessctl
"XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
"XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
# Pulse Audio controls
"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%"; #increase sound volume
"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%"; #decrease sound volume
"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle"; # mute sound
# Media player controls
"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
    };
gaps = {
inner = 5;
outer = 5;
};
bars = [
{
id = "bar-0";
position = "top";
trayOutput = "eDP-1";
colors = {
background = "#323232";
statusline = "#ffffff";
#inactiveWorkspace = [ "#32323200 #32323200 #5c5c5c"];
};
}
];
terminal = "alacritty";
};
extraSessionCommands = "
# https://github.com/swaywm/sway/wiki#disabling-client-side-qt-decorations
# needs qt5.qtwayland in systemPackages
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=\"1\"
# Pipewire???
export MOZ_ENABLE_WAYLAND=\"1\";
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
";
extraConfig = "
default_border pixel 6
#input \"1:1:AT_Translated_Set_2_keyboard\" {
input * {
 xkb_layout de
}
";
};

# GTK Icon Theme
gtk = {
enable = true;
iconTheme = {
package = pkgs.gnome3.gnome_themes_standard;
name = "Adwaita";
};
};

# Looks like there is not dunst package that supports wayland
# despite the fact dunst supports wayland
# https://github.com/dunst-project
programs.mako = {
enable = true;
anchor = "bottom-center";
};

#  programs.firefox = {
#enable = true;
#package = pkgs.firefox-wayland;
#profiles = {
#work = {
#isDefault = true;
#settings = {
#"general.smoothScrooll" = false;
#"general.usragent.locale" = "us-US";
#};
#};
#};
#};

# Enable font management
fonts.fontconfig.enable = true;

    programs.git = {
      enable = true;
      userName = "Schäfer, Denny";
      userEmail = "denny.schaefer@immowelt.de";
      extraConfig = {
        color.ui = "auto";
        core.editor = "vim";
        core.excludesfile = "~/.gitignore";
        pull.ff = "only";
      };
    };

    programs.rofi = {
      enable = true;
      package = unstable.wofi;

    };

  # https://www.linux.com/news/accelerating-openssh-connections-controlmaster
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    controlMaster = "auto";
    controlPath = "/tmp/control_%l_%h_%p_%r";
    controlPersist = "10m";
    };

    #programs.i3status-rust.enable = true;

    home.file = {
      ".gitignore".source = ../gitignore;
      ".bashrc".source = ../bash/work_bashrc;
      ".vim/backup/.dummy".source = ../bash/emptyfile;
      ".vim/swap/.dummy".source = ../bash/emptyfile;
      ".vim/undo/.dummy".source = ../bash/emptyfile;
    };
    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
      pinentryFlavor = "tty";
    };

    programs.home-manager = {
      enable = true;
      path = https://github.com/nix-community/home-manager/archive/master.tar.gz;
    };
}
