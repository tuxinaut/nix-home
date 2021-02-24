{ pkgs, lib, config, ... }:

let
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';

  vim-wayland-clipboard = pkgs.vimUtils.buildVimPlugin {
    name = "wayland-clipboard";
    src = pkgs.fetchFromGitHub {
      owner = "jasonccox";
      repo = "vim-wayland-clipboard";
      rev= "2dc05c0f556213068a9ddf37a8b9b2276deccf84";
      sha256= "sha256:16x7dk1x9q8kzjcgapgb9hw8hm4w8v1g6pzpiz6ccsd0ab0jzf40";
    };

    buildInputs = [ pkgs.zip pkgs.vim ];
  };

  # See https://nixos.wiki/wiki/Vim
  my_vim_configurable = pkgs.vim_configurable.override {
    python = pkgs.python38Full;
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
    vim-airline-themes
    molokai
    tagbar
    quick-scope
    vim-wayland-clipboard
  ];

  modifier = config.wayland.windowManager.sway.config.modifier;
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in

{
  home.packages = [
    # Internet and email
    pkgs.firefox-wayland
    pkgs.thunderbird
    pkgs.chromium
    # Clipboard
    pkgs.wl-clipboard
    pkgs.clipman
    pkgs.keepassxc
    pkgs.signal-desktop
    unstable.slack
    pkgs.pavucontrol
    # Display management
    pkgs.wdisplays
    pkgs.wlr-randr
    pkgs.yubioath-desktop
    # https://github.com/altdesktop/playerctl
    pkgs.playerctl
    # terminal
    pkgs.bashCompletion
    pkgs.starship
    pkgs.hstr
    # fonts
    #pkgs.font-awesome
    pkgs.font-awesome-ttf
    pkgs.powerline-fonts
    pkgs.gnome3.gnome-font-viewer
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
    # Tools
    pkgs.htop
    pkgs.fzf
    pkgs.jq
    # Unstable because of error regarding autocompletionn
    unstable.awscli2
    pkgs.git
    pkgs.gnupg
    # Needed for Immowelt SSO
    pkgs.python38Packages.virtualenv
    pkgs.phantomjs
    pkgs.chromedriver
    pkgs.google-chrome
    # Communication
    unstable.teams
    # Backlight
    pkgs.brightnessctl
    # Misc tools
    pkgs.gnome3.gnome-system-monitor
    pkgs.killall
  ];

wayland.windowManager.sway = {
  enable = true;
  package = unstable.sway;
  wrapperFeatures = {
    base = true;
    gtk = true;
  };
  config = {
    assigns = {
      "5:" = [
        { class = "^Signal$"; }
        { class = "^Slack$"; }
      ];
    };
output = {
"*" = {
bg = "/etc/nixos/wallpaper.png fill";
};
};
fonts = [
"Font Awesome 5 free 10"
"Font Awesome 5 Brands 10"
"Hack 10"
];
modifier = "Mod4";
  keybindings =
    lib.mkOptionDefault {
#"${modifier}+Tab" = "exec ${unstable.wofi}/bin/wofi -d --show run,drun";
# Ugly
"${modifier}+Tab" = "exec bash /home/dschaefer/bin/sway-window-switcher";
"${modifier}+Shift+h" = "move workspace to output left";
"${modifier}+Shift+l" = "move workspace to output right";
"${modifier}+Shift+j" = "move workspace to output up";
"${modifier}+Shift+k" = "move workspace to output down";
"Control+${modifier}+h" = "workspace prev";
"Control+${modifier}+l" = "workspace next";
"Control+${modifier}+q" = "workspace back_and_forth";
# https://fontawesome.com/cheatsheet/free/brands
# https://fontawesome.com/cheatsheet/free/solid
"${modifier}+1" = "workspace number 1:";
"${modifier}+2" = "workspace number 2:";
"${modifier}+3" = "workspace number 3:";
"${modifier}+4" = "workspace number 4:";
"${modifier}+5" = "workspace number 5:";
"${modifier}+6" = "workspace number 6";
"${modifier}+7" = "workspace number 7";
"${modifier}+8" = "workspace number 8:";
"${modifier}+9" = "workspace number 9:";
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
# Dunst
"Control+Shift+d" = "exec dunstctl close";
"Control+Shift+h" = "exec dunstctl history-pop";
    };
gaps = {
inner = 5;
outer = 5;
};
bars = [
{
id = "bar-0";
position = "top"; fonts = [
"Hack 10"
];

trayOutput = "eDP-1";
colors = {
background = "#323232";
statusline = "#ffffff";
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
# Enable Capslock and Numlock
#XKB_capslock enable
xkb_numlock enable
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
# FIXME: It broke with unstable!
#
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

services.gammastep = {
  enable = true;
  latitude = "53.551086";
  longitude = "9.993682";
  settings = {
    general = {
      adjustment-method = "wayland";
      fade = 1;
    };
  };
  #tray = true;
};


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

  programs.alacritty = {
    enable = true;
    settings = {
      env = {
      TERM = "xterm-256color";
      };
      font = {
        normal.family = "Hack";
      };
      dynamic_title = true;
    };
  };

  programs.bash = {
    enable = true;
    profileExtra = "
if [ -z $DISPLAY ] && [ \"$(tty)\" == \"/dev/tty1\" ]; then
  exec sway
fi
    ";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "numbers";
    };
    themes = {
  dracula = builtins.readFile (pkgs.fetchFromGitHub {
    owner = "dracula";
    repo = "sublime"; # Bat uses sublime syntax for its themes
    rev = "26c57ec282abcaa76e57e055f38432bd827ac34e";
    sha256 = "019hfl4zbn4vm4154hh3bwk6hm7bdxbr1hdww83nabxwjn99ndhv";
  } + "/Dracula.tmTheme");
    };
  };

    #programs.i3status-rust.enable = true;

    home.file = {
      "bin/sway-window-switcher".source = ../sway/sway-bash-window-switcher.sh;
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

    # https://github.com/emersion/kanshi
    services.kanshi = {
      enable = true;
    };

    programs.home-manager = {
      enable = true;
      path = https://github.com/nix-community/home-manager/archive/master.tar.gz;
    };
}
