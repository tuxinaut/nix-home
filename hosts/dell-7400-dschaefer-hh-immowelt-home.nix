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
    vim-better-whitespace
    vim-airline-themes
    molokai
    tagbar
    quick-scope
    vim-wayland-clipboard # Needed for exchange the + register with the (wayland) clipboard
    editorconfig-vim # https://github.com/editorconfig/editorconfig-vim https://editorconfig.org/
  ];

  modifier = config.wayland.windowManager.sway.config.modifier;
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in

{
  home.packages = [
    pkgs.iw
    pkgs.ethtool

    pkgs.keepassxc
    pkgs.libnotify # Send notifications
    pkgs.gnome3.gnome-calculator
    pkgs.fd # https://github.com/sharkdp/fd
    # Internet and email
    pkgs.firefox-wayland
    pkgs.thunderbird
    pkgs.chromium
    pkgs.google-chrome
    # Screensharing via chromium
    pkgs.xdg-desktop-portal-wlr
    # Clipboard
    pkgs.wl-clipboard
    pkgs.clipman
    # Display management
    pkgs.wdisplays
    pkgs.wlr-randr
    # Yubikey Totp
    pkgs.yubioath-desktop
    # Multimedia
    pkgs.playerctl # https://github.com/altdesktop/playerctl
    pkgs.pavucontrol
    # terminal
    pkgs.bashCompletion
    pkgs.hstr
    pkgs.gitAndTools.scmpuff
    # fonts
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
    pkgs.jq
    unstable.awscli2 # Unstable because of error regarding autocompletionn
    pkgs.git
    pkgs.gnupg
    # Needed for Immowelt SSO
    pkgs.python38Packages.virtualenv
    pkgs.phantomjs
    pkgs.chromedriver
    # Communication
    unstable.teams
    pkgs.signal-desktop
    unstable.slack
    # System
    pkgs.brightnessctl # Backlight management
    pkgs.lm_sensors
    pkgs.htop
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
    # Not sure if this will work
    startup = [
      {
        command = "wl-paste  -t text --watch clipman store --max-items=1000 -P --histpath=\"~/.local/share/clipman-primary.json\" &";
        notification = false;
      }
      {
        command = "wl-paste -p  -t text --watch clipman store --max-items=1000 -P --histpath=\"~/.local/share/clipman-primary.json\" &";
        notification = false;
      }
    ];
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
position = "top";
statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/dschaefer/.config/i3status-rust/config-main.toml";
fonts = [
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
# https://man.archlinux.org/man/xkeyboard-config.7
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

#services.dunst = {
#  enable = true;
#};

# Looks like there is not dunst package that supports wayland
# despite the fact dunst supports wayland
# https://github.com/dunst-project
#programs.mako = {
#enable = true;
#anchor = "bottom-center";
#};
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

    programs.fzf = {
      enable = true;
      enableBashIntegration = true;
    };

    # https://github.com/starship/starship
    programs.starship = {
      enable = true;
      # Not possible yet because the current .bashrc
      # overrides the autogenerated .bashrc
      #enableBashIntegration = true;
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
    matchBlocks = {
      "private.github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_rsa_private";
      };
      # Fix that the GPG/SSH agent unlock dialog appears in some random terminal
      #
      # https://bugzilla.mindrot.org/show_bug.cgi?id=2824#c9
      # https://unix.stackexchange.com/questions/280879/how-to-get-pinentry-curses-to-start-on-the-correct-tty
      "* exec \"gpg-connect-agent UPDATESTARTUPTTY /bye\"" = {};
    };
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
    initExtra = "
[[ -f ~/.bashrc_static ]] && . ~/.bashrc_static
";
shellAliases = {
g="git";
gcb="git checkout -b";
gpl="git pull";
gplr="git pull --rebase";
gps="git push";
gpsf="git push --force";
gfa="git fetch --all";
reload=". ~/.bash_profile";
  };
#  sessionVariables = {
#    EDITOR = "vim";
#  };
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

  programs.i3status-rust = {
    enable = true;
    bars = {
      main = {
        theme = "solarized-dark";
        icons = "awesome5";
        blocks = [
{
block = "backlight";
device = "intel_backlight";
}
{
  block = "battery";
  device = "BAT0"
driver = "upower";
format = "{percentage}% {time}";
}
{
block = "music";
#buttons = "[play, next]";
marquee = true;
}
{
block = "net";
device = "wlo1";
format = "{ssid} {signal_strength} {ip}";
interval = 5;
use_bits = false;
hide_inactive = true;
}
{
block = "net";
device = "enp57s0u1u2";
format = "{ip}";
interval = 5;
use_bits = false;
hide_inactive = true;
}
          {
              block = "disk_space";
              path = "/";
              alias = "/";
              info_type = "available";
              unit = "GB";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
            }
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{Mup}%";
              format_swap = "{SUp}%";
            }
            {
              block = "load";
              interval = 1;
              format = "{1m}";
            }
            { block = "sound"; }
            {
              block = "time";
              interval = 60;
              format = "%a %Y-%m-%d %R";
            }
        ];
      };
    };
  };

    home.file = {
      "bin/sway-window-switcher".source = ../sway/sway-bash-window-switcher.sh;
      ".gitignore".source = ../gitignore;
      ".bashrc_static".source = ../bash/work_bashrc;
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
