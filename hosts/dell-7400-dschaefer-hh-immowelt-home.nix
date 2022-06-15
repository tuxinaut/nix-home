{ pkgs, lib, config, ... }:

let
  homeDirectory = "/home/dschaefer";

  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';

  modifier = config.wayland.windowManager.sway.config.modifier;
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };

  vimPluginUnstable = with unstable.vimPlugins; [
    everforest
  ];
in

  {
#  nixpkgs.overlays = [(
#    self: super: {
#      slack  = super.slack.overrideAttrs (old: {
#        x86_64-linux = super.fetchurl {
#          url = "https://downloads.slack-edge.com/releases/linux/4.23.0/prod/x64/slack-desktop-4.23.0-amd64.deb";
#          sha256 = "1wsrxacnj9f3cb6as7ncbdvi02jqcbyc7ijsavps5bls9phkp0is";
#        };
#      });
#    }
#  )];


  home.sessionPath = [
    "${homeDirectory}/bin"
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs.dircolors = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = [
    # languages runtimes
    pkgs.nodejs-16_x
    pkgs.nodePackages.typescript
    pkgs.terraform-ls # Terraform Language Server
    # backup
    pkgs.borgbackup
    pkgs.borgmatic

    pkgs.zathura
    pkgs.solaar # Logitech mouse
    pkgs.gimp
    pkgs.grim
    pkgs.sway-contrib.grimshot
    pkgs.dunst # Workaround to control dunst via cli
    pkgs.bemenu
    # packages for i3status-rust
    pkgs.iw
    pkgs.ethtool

    pkgs.keepassxc
    pkgs.libnotify # Send notifications
    pkgs.gnome3.gnome-calculator
    pkgs.fd # https://github.com/sharkdp/fd
    # Internet and email
    #  Firefox popups not rendered on some multi-output setups #6147
    # https://github.com/swaywm/sway/issues/6147
    pkgs.firefox-wayland
    pkgs.thunderbird
    pkgs.chromium
    pkgs.google-chrome
    # Screensharing
    pkgs.xdg-desktop-portal-wlr
    pkgs.obs-studio-plugins.wlrobs # needed for wayland (pipewire)
    pkgs.obs-studio
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
    pkgs.complete-alias
    pkgs.neofetch
    # fonts
    pkgs.font-awesome-ttf
    pkgs.powerline-fonts
    pkgs.gnome3.gnome-font-viewer
    # Tools
    pkgs.gnumake
    pkgs.jq
    pkgs.awscli2 # Unstable because of error regarding autocompletionn
    pkgs.saml2aws # retrieve AWS temporary credentials
    pkgs.git
    pkgs.meld # diff tool
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
    pkgs.wofi-emoji
    pkgs.sirula
    pkgs.swayr
    pkgs.wofi
    unstable.joplin-desktop
  ];

wayland.windowManager.sway = {
  enable = true;
  package = pkgs.sway;
  wrapperFeatures = {
    base = true;
    gtk = true;
  };
  config = {
    # Not sure if this will work
    startup = [
      {
        command = "env RUST_BACKTRACE=1 RUST_LOG=swayr=debug swayrd > /tmp/swayrd.log 2>&1 &";
      }
      {
        command = "wl-paste -n  -t text --watch ${pkgs.clipman}/bin/clipman store --max-items=200 -P --histpath=\"~/.local/share/clipman-primary.json\" &";
      }
      {
        # FIXME
        # Maybe shorter
        # https://www.reddit.com/r/swaywm/comments/ki4z9a/sync_clipboards/
        command = "wl-paste -p  -t text --watch ${pkgs.clipman}/bin/clipman store --max-items=200 -P --histpath=\"~/.local/share/clipman-primary.json\" &";
      }
    ];
    assigns = {
      "2:" = [
        { class = "^Thunderbird$"; }
      ];
      "5:" = [
        { class = "^Signal$"; }
        { class = "^Slack$"; }
        { class = "^Microsoft Teams"; }
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
#"${modifier}+Tab" = "exec bash ${homeDirectory}/bin/sway-window-switcher";
"${modifier}+Tab" = "exec ${pkgs.sirula}/bin/sirula";
"Control+${modifier}+Space" = "exec ${pkgs.swayr}/bin/swayr switch-window";

"${modifier}+Shift+s" = "exec ${pkgs.wofi-emoji}/bin/wofi-emoji";
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

"${modifier}+Shift+1" = "move container to workspace 1:";
"${modifier}+Shift+2" = "move container to workspace 2:";
"${modifier}+Shift+3" = "move container to workspace 3:";
"${modifier}+Shift+4" = "move container to workspace 4:";
"${modifier}+Shift+5" = "move container to workspace 5:";
"${modifier}+Shift+6" = "move container to workspace 6";
"${modifier}+Shift+7" = "move container to workspace 7";
"${modifier}+Shift+8" = "move container to workspace 8:";
"${modifier}+Shift+9" = "move container to workspace 9:";

# Backlight
# needs brightnessctl
"XF86MonBrightnessUp" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
"XF86MonBrightnessDown" = "exec --no-startup-id ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";
# Pulse Audio controls
"XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +5% && ${homeDirectory}/bin/dunst_volume"; #increase sound volume
"XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -5% && ${homeDirectory}/bin/dunst_volume"; #decrease sound volume
# FIXME
"XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle"; # mute sound
"Control+Shift+m" = "exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && pkill -SIGRTMIN+4 i3status-rs"; # mute default mic
# Media player controls
"XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
"XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
"XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
# Dunst
"Control+Shift+d" = "exec dunstctl close";
"Control+Shift+h" = "exec dunstctl history-pop";
"Control+Shift+n" = "exec dunstctl set-paused toggle";
#Clipboard
#$(swaymsg -r -t get_outputs | jq '. [] | select (.focused == true) | .name | split ("-") | last')
"Control+Shift+c" = "exec ${pkgs.clipman}/bin/clipman pick --histpath \"${homeDirectory}/.local/share/clipman-primary.json\" --max-items=1000 -t bemenu -T'bemenu -b -i -l 10 --nb \"#002b36\" --tb \"#002b36\" --fb \"#002b36\" --fn \"Hack 14\" -p \"pick >\" -b -P \"\" --hb \"#002b36\" --hf \"#b5890\" --tf \"#fdf6e3\" --nf \"#fdf6e3\" -m focused'";

"Control+Shift+s" = "exec bash ${homeDirectory}/bin/screenshot";

"${modifier}+Shift+e" = "mode \"\$mode_system\"";
    };
gaps = {
inner = 5;
outer = 5;
};
bars = [
{
id = "bar-0";
position = "top";
statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${homeDirectory}/.config/i3status-rust/config-main.toml";
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
export MOZ_ENABLE_WAYLAND=\"1\"
export MOZ_DBUS_REMOTE=\"1\"
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway
";
extraConfig = "
set $mode_system System (l)  lock, (s)  suspend, (h)  hibernate, (r)  reboot, (Shift+s)  shutdown
mode \"$mode_system\" {
  bindsym l exec --no-startup-id swaylock -i /etc/nixos/wallpaper.png, mode \"default\"
  bindsym s exec --no-startup-id systemctl suspend, mode \"default\"
  bindsym h exec --no-startup-id systemctl hibernate, mode \"default\"
  bindsym r exec --no-startup-id systemctl reboot, mode \"default\"
  bindsym Shift+s exec --no-startup-id systemctl poweroff, mode \"default\"

  # back to normal: Enter or Escape
  bindsym Return mode \"default\"
  bindsym Escape mode \"default\"
}


default_border pixel 6
#input \"1:1:AT_Translated_Set_2_keyboard\" {
input * {
# https://man.archlinux.org/man/xkeyboard-config.7
xkb_layout de
xkb_variant nodeadkeys
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

services.dunst = {
  enable = true;
  settings = {
    global = {

    monitor = 0;
    follow = "keyboard";
    width = 10000;
    height = 100;
    origin = "bottom-left";
    offset = "0x0";

    progress_bar = true;
    progress_bar_height = 10;
    progress_bar_frame_width = 1;
    progress_bar_min_width = 150;
    progress_bar_max_width = 1900;

    separator_height = 2;
    padding = 8;

    horizontal_padding = 8;

    text_icon_padding = 0;
    frame_width = 3;
    frame_color = "#93a1a1";
    separator_color = "#93a1a1";
    font = "Hack 12";
    format = "<b>%s</b>\\n%b";
    };
#"Control+Shift+c" = "exec ${pkgs.clipman}/bin/clipman pick --histpath \"${homeDirectory}/.local/share/clipman-primary.json\" --max-items=1000 -t bemenu -T'bemenu -b -i -l 10 --nb \"#002b36\" --tb \"#002b36\" --fb \"#002b36\" --fn \"Hack 14\" -p \"pick >\" -b -P \"\" --hb \"#002b36\" --hf \"#b5890\" --tf \"#fdf6e3\" --nf \"#fdf6e3\"'";
urgency_low = {
    # IMPORTANT: colors have to be defined in quotation marks.
    # Otherwise the "#" and following would be interpreted as a comment.
    background = "#073642";
    foreground = "#657b83";
    timeout = 10;
    # Icon for notifications with low urgency, uncomment to enable
    #icon = /path/to/icon
  };

urgency_normal = {
    background = "#002b36";
    foreground = "#fdf6e3";
    timeout = 10;
    # Icon for notifications with normal urgency, uncomment to enable
    #icon = /path/to/icon
  };

urgency_critical = {
    background = "#dc322f";
    foreground = "#eee8d5";
    frame_color = "#ff0000";
    timeout = 0;
  };
  };
};

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

programs.vim = {
  enable = true;
  plugins = with pkgs.vimPlugins; [
    coc-nvim
    coc-json
    coc-tsserver

    vim-wayland-clipboard # https://github.com/jasonccox/vim-wayland-clipboard/
    iceberg-vim
    tabular
    vim-indent-guides
    syntastic
    vim-fugitive
    nerdtree
    ctrlp-vim
    vim-airline
    vim-multiple-cursors
    vim-surround
    vim-better-whitespace
    vim-airline-themes
    molokai
    tagbar
    quick-scope
    vim-wayland-clipboard # Needed for exchange the + register with the (wayland) clipboard
    editorconfig-vim # https://github.com/editorconfig/editorconfig-vim https://editorconfig.org/
    fzf-vim # https://github.com/junegunn/fzf.vim/
  ] ++ vimPluginUnstable;

  extraConfig = ''
    ${ (builtins.readFile ../vim/vimrc) }
  '';
};



    programs.git = {
      enable = true;
      userName = "Schäfer, Denny";
      userEmail = "denny.schaefer@immowelt.de";
      signing = {
        key = "C9FC08DD";
        signByDefault = true;
        gpgPath = "gpg2";
      };
      extraConfig = {
        color.ui = "auto";
        core.editor = "vim";
        core.excludesfile = "~/.gitignore";
        pull.ff = "only";
        branch.sort = "authordate";
      };
      includes = [
        {
          path = "~/.gitprivate";
          condition = "gitdir:~/workspace/private/";
        }
        {
          path = "~/.gitprivate";
          condition = "gitdir:/etc/nixos/";
        }
      ];
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
      enableBashIntegration = true;
      settings = {

username = {
style_user = "white bold";
style_root = "black bold";
format = "user: [$user]($style) ";
disabled = false;
show_always = false;
};
nodejs = {
  # https://github.com/starship/starship/pull/1649
  symbol = " ";
};
      };
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

  # https://github.com/alacritty/alacritty/blob/master/alacritty.yml
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
      background_opacity = 0.9;
      scrolling = {
        history = 50000;
      };
      save_to_clipboard = {
        save_to_clipboard = true;
      };
      key_bindings = [
        {
          # Open a new alacritty instance in the same directory
          key = "Return";
          mods = "Control|Shift";
          action = "SpawnNewInstance";
        }
        {
          key = "A";
          mode = "Vi|~Search";
          mods = "Shift";
          action = "Last";
        }

      ];
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

# https://github.com/cykerway/complete-alias
if [[ -f ${pkgs.complete-alias}/bin/complete_alias ]]; then
  . ${pkgs.complete-alias}/bin/complete_alias
  complete -F _complete_alias \"\${!BASH_ALIASES[@]}\"
fi

export PATH=\"${homeDirectory}/.npm-packages/bin:\$PATH\"

${pkgs.neofetch}/bin/neofetch
";
shellAliases = {
".."="cd ..";
"..."="cd .. && cd ..";
# https://github.com/scmbreeze/scm_breeze/blob/master/lib/git/aliases.sh
# https://github.com/scmbreeze/scm_breeze/blob/4f1e42165252cc63a541ae13e760e286a5710a7a/git.scmbrc.example
g="git";
gaa="git add --all";
gap="git add -p";
gash="git stash";
gasha="git stash apply";
gashl="git stash list";
gashp="git stash pop";
gau="git add -u";
gb="git branch";
gba="git branch --all";
gbd="git-delete-branches";
gbl="git blame";
gc="git commit";
gcb="git checkout -b";
gce="git clean";
gcef="git clean -fd";
gcl="git clone";
gcm="git commit --amend";
gcmh="git commit --amend -C HEAD";
gcom="git checkout $(if [[ $(git branch --list | grep -c master) -eq 1 ]]; then echo 'master'; else echo 'main'; fi)";
gcp="git cherry-pick";
gcv="git commit --verbose";
gdc="git diff --cached";
gdnw="git diff -w";
gdw="git diff --word-diff";
gfa="git fetch --all";
gll="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
glm="git log --oneline ...$(if [[ $(git branch --list | grep -c master) -eq 1 ]]; then echo 'master'; else echo 'main'; fi)";
gpl="git pull";
gplp="git pull --prune";
gplr="git pull --rebase";
gps="git push";
gpsf="git push --force";
gr="git remote -v";
grb="git rebase";
grbc="git rebase --continue";
grbi="git rebase --interactive";
grbim="git rebase --interactive --autosquash $(git log --oneline --format=%H $(if [[ $(git branch --list | grep -c master) -eq 1 ]]; then echo 'master'; else echo 'main'; fi)... | tail -n1)^";
grsh="git reset --hard";
grsl="git reset HEAD~";
gss="git status -s";
gt="git tag";
gwc="git whatchanged";
glme="git log --oneline --author=Denny";
ns="nix-shell -p";
reload=". ~/.bash_profile";
tfp="terraform plan -out \"$(basename $(pwd)).tfplan\"";
tfa="terraform apply -auto-approve \"$(basename $(pwd)).tfplan\"";
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
block = "notify";
#driver = "dunst";
format = "{state}";
}
{
  block = "custom";
  command = "bash ${homeDirectory}/bin/mic_checker";
  on_click = "pactl set-source-mute @DEFAULT_SOURCE@ toggle";
  signal = 4;
  interval = 30;
}
{
block = "backlight";
device = "intel_backlight";
}
          {
block = "bluetooth";
mac = "00:0E:DD:0A:E9:5F";
label = "Shure BT2";
hide_disconnected = true;
}
          {
block = "bluetooth";
mac = "00:02:3C:7C:9C:0D";
label = "Outlier Sports";
hide_disconnected = true;
}
          {
block = "bluetooth";
mac = "DA:0B:DA:C7:BD:A0";
label = "MX Ergo";
hide_disconnected = true;
}
{
  block = "battery";
  device = "BAT0";
driver = "upower";
format = "{percentage}% {time}";
}
{
block = "music";
marquee = true;
}
{
block = "net";
device = "wlo1";
format = "{ssid} {signal_strength} {ip}";
interval = 5;
#use_bits = false; # broken?
hide_inactive = true;
}
{
block = "net";
device = "ppp0";
format = "{ip}";
interval = 5;
hide_inactive = true;
}
{
block = "net";
device = "enp57s0u1u2";
format = "{ip}";
interval = 5;
#use_bits = false;
hide_inactive = true;
}
#          {
#              block = "disk_space";
#              path = "/";
#              alias = "/";
#              info_type = "available";
#              unit = "GB";
#              interval = 60;
#              warning = 20.0;
#              alert = 10.0;
#            }
            {
              block = "memory";
              display_type = "memory";
              format_mem = "{mem_used_percents}%";
              format_swap = "{swap_used_percents}%";
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
      ".config/sirula/config.toml".source = ../sirula/config.toml;
      ".config/sirula/style.css".source = ../sirula/style.css;
      "bin/screenshot".source = ../bash/screenshot.sh;
      "bin/mic_checker".source = ../bash/mic_checker.sh;
      "bin/dunst_volume".source = ../bash/dunst_volume.sh;
      ".gitignore".source = ../gitignore;
      ".gitprivate".source = ../gitprivate;
      ".bashrc_static".source = ../bash/work_bashrc;
      ".vim/backup/.dummy".source = ../bash/emptyfile;
      ".vim/swap/.dummy".source = ../bash/emptyfile;
      ".vim/undo/.dummy".source = ../bash/emptyfile;
      "Pictures/.dummy".source = ../bash/emptyfile;
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      maxCacheTtlSsh = 14400;
      enableSshSupport = true;
      pinentryFlavor = "tty";
      extraConfig = "
        #keyid-format LONG
      ";
    };

    # https://github.com/emersion/kanshi
    services.kanshi = {
      enable = true;
    };

    # Using Bluetooth headset buttons to control media player
    # https://nixos.wiki/wiki/Bluetooth
    systemd.user.services.mpris-proxy = {
      Unit = {
        Description = "Mpris proxy";
        After = [ "network.target" "sound.target" ];
      };
  Service = {ExecStart = "${pkgs.bluez}/bin/mpris-proxy";};
  Install = {WantedBy = [ "default.target" ];};
};
# https://www.freedesktop.org/software/systemd/man/systemd.mount.html
# https://github.com/nix-community/home-manager/pull/1629
#systemd.user.mounts = {
#       "home-dschaefer-nas-backup" = {
#    Unit = {
#      Description = "Example description";
#      Documentation = [ "man:example(1)" "man:example(5)" ];
#    };
#
#    Mount = {
#      What = "//nas.tuxinaut.de/Sicherungen";
#       Where = "/home/dschaefer/nas/backup";
#      Type = "cifs";
##      noCheck = true;
#      options = [
#        "user"
#        "uid=1000"
#        "gid=1000"
#        "credentials=/etc/nas"
#        "nofail"
#        "x-systemd.automount"
#        "x-systemd.device-timeout=2s"
#        "x-systemd.mount-timeout=2s"
#      ];
#    };
#  };
#};

    programs.home-manager = {
      enable = true;
      path = https://github.com/nix-community/home-manager/archive/release-21.05.tar.gz;
      # Needed becuase of broken rofi
      #path = https://github.com/nix-community/home-manager/archive/9b7a90daa17022c428e3b6da36814f5f9a804a35.tar.gz;
    };
}
