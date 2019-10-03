{ pkgs, lib, config, ... }:

let
  modifier = "Mod4";
  move = "50px";

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
in
{
  home.keyboard.layout = "de";

    home.packages = [
      pkgs.htop
      pkgs.git
      pkgs.terminator
      pkgs.firefox
      pkgs.thunderbird
      pkgs.gnupg
      pkgs.parcellite
      pkgs.redshift
      pkgs.vlc
      pkgs.youtubeDL
      pkgs.hugo
      pkgs.borgbackup
      pkgs.kbfs
      pkgs.keybase
      pkgs.keybase-gui
      pkgs.meld
      pkgs.hstr
      pkgs.gimp
      pkgs.yubikey-personalization-gui
      pkgs.yubioath-desktop
      pkgs.lm_sensors
      pkgs.keepassxc
      pkgs.dropbox
      pkgs.blueman
      pkgs.ranger
      pkgs.powerline-fonts
      pkgs.wget
      pkgs.usbutils
      pkgs.gnome3.gnome-keyring
      pkgs.gnome3.dconf
      pkgs.pavucontrol
      pkgs.lsof
      pkgs.xorg.xev
      pkgs.feh
      pkgs.libnotify
      pkgs.bluez
      pkgs.bash-completion
      pkgs.unzip
      pkgs.calibre
      pkgs.nix-index
      pkgs.atool
      pkgs.hicolor-icon-theme
      pkgs.gnome3.gnome_themes_standard
      pkgs.gnome3.defaultIconTheme
      pkgs.go-mtpfs
      pkgs.zathura
      pkgs.gnumake
      pkgs.yubikey-neo-manager
      pkgs.file
      pkgs.scrot
      pkgs.awscli
      pkgs.imagemagick
      pkgs.inkscape
      pkgs.ruby
      pkgs.ffmpeg
      pkgs.kdenlive
      pkgs.breeze-qt5
      pkgs.breeze-gtk
      pkgs.breeze-icons
      pkgs.s-tui
      pkgs.xclip
      pkgs.easytag
      pkgs.bind
      pkgs.torbrowser
      pkgs.libreoffice-fresh
      pkgs.slack
      pkgs.colord
      pkgs.colord-gtk
      pkgs.killall
      pkgs.steam-run-native
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
      pkgs.acpilight
    ];

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Darker";
    };
    iconTheme = {
#      package = pkgs.moka-icon-theme;
      name = "Adwaita";
    };
  };

  qt = {
    enable = true;
    useGtkTheme = true;
  };


    xsession.enable = true;

    xsession.windowManager.i3 = {
      enable = true;
      extraConfig = ''
        set $mode_system System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown, (Shift+p) Presenter Modus
        mode "$mode_system" {
          bindsym l exec --no-startup-id ~/.config/i3/i3-exit lock, mode "default"
          bindsym e exec --no-startup-id ~/.config/i3/i3-exit logout, mode "default"
          bindsym s exec --no-startup-id ~/.config/i3/i3-exit suspend, mode "default"
          bindsym h exec --no-startup-id ~/.config/i3/i3-exit hibernate, mode "default"
          bindsym r exec --no-startup-id ~/.config/i3/i3-exit reboot, mode "default"
          bindsym Shift+s exec --no-startup-id ~/.config/i3/i3-exit shutdown, mode "default"
          bindsym Shift+p exec --no-startup-id ~/.config/i3/i3-exit present, mode "default"

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
        }
      '';
      config = {
        modifier = "${modifier}";
        focus.forceWrapping = true;
        keybindings =
          lib.mkOptionDefault {
            "${modifier}+1" = "workspace 1:Web";
            "${modifier}+2" = "workspace 2:Email";
            "${modifier}+3" = "workspace 3:Terminal";
            "${modifier}+Shift+1" = "move container to workspace 1:Web";
            "${modifier}+Shift+2" = "move container to workspace 2:Email";
            "${modifier}+Shift+3" = "move container to workspace 3:Terminal";
            "${modifier}+Shift+Left" = "move left ${move}";
            "${modifier}+Shift+Down" = "move down ${move}";
            "${modifier}+Shift+Up" = "move up ${move}";
            "${modifier}+Shift+Right" = "move right ${move}";
            "${modifier}+space" = "focus mode_toggle";
            "${modifier}+a" = "focus parent";
            "${modifier}+SHIFT+plus" = "move scratchpad";
            "${modifier}+plus" = "scratchpad show";
            "${modifier}+x" = "move workspace to output right";
            "${modifier}+y" = "move workspace to output up";
            "Control+${modifier}+a" = "workspace prev";
            "Control+${modifier}+s" = "workspace next";
            "Control+${modifier}+q" = "workspace back_and_forth";
            "${modifier}+Tab" = "exec rofi -show combi run -threads 0";
            "${modifier}+Shift+e" = "mode \"\$mode_system\"";
            "XF86AudioRaiseVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 5%+ unmute";
            "XF86AudioLowerVolume" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 5%- unmute";
            "XF86AudioMute" = "exec ${pkgs.alsaUtils}/bin/amixer -q set Master 1+ toggle";
            "XF86MonBrightnessUp" = "exec xbacklight -inc 10";
            "XF86MonBrightnessDown" = "exec xbacklight -dec 10";
          };
        modes = {
          resize = {
            j = "resize shrink left width 10 px or 10 ppt";
            "Shift+J" = "resize grow left width 10 px or 10 ppt";
            k = "resize shrink down 10 px or 10 ppt";
            "Shift+K" = "resize grow down 10 px or 10 ppt";
            l = "resize shrink up 10 px or 10 ppt";
            "Shift+L" = "resize grow up 10 px or 10 ppt";
            odiaeresis = "resize shrink right 10 px or 10 ppt";
            "Shift+Odiaeresis" = "resize grow right 10 px or 10 ppt";
            Left = "resize shrink left 10 px or 10 ppt";
            "Shift+Left" = "resize grow left 10 px or 10 ppt";
            Down = "resize shrink down 10 px or 10 ppt";
            "Shift+Down" = "resize grow down 10 px or 10 ppt";
            Up = "resize shrink up 10 px or 10 ppt";
            "Shift+Up" = "resize grow up 10 px or 10 ppt";
            Right = "resize shrink right 10 px or 10 ppt";
            "Shift+Right" = "resize grow right 10 px or 10 ppt";
            Return = "mode \"default\"";
            Escape = "mode \"default\"";
          };
        };
        startup = [
          {
            command = "feh --bg-scale '/home/tuxinaut/pictures/wallpaper.png'";
            notification = false;
          }
          {
            command = "blueman-applet";
            notification = false;
          }
          {
            command = "xset dpms 600";
            notification = false;
          }
          {
            command = "i3-msg 'workspace 1:Web; exec firefox'";
            notification = false;
          }
          {
            command = "i3-msg 'workspace 1:Web; exec keepassxc'";
            notification = false;
          }
          {
            command = "i3-msg 'workspace 2:Email; exec thunderbird'";
            notification = false;
          }
          {
            command = "i3-msg 'workspace 3:Terminal; exec terminator'";
            notification = false;
          }
          {
            command = "gtk-redshift";
          }
          {
            command = "parcellite";
          }
          {
            command = "dropbox start";
          }
#          {
#            command = "nm-applet";
#          }
        ];
        window.commands = [
          {
            command = "floating disable";
            criteria = { class = "Thunderbird"; };
          }
          {
            command = "move to workspace \"2:EMail\"";
            criteria = { class = "Thunderbird"; };
          }
        ];
        bars = [
          {
            id = "bar-0";
            position = "top";
          }
        ];
      };
    };

    programs.git = {
      enable = true;
      userName = "Denny Schäfer";
      userEmail = "denny.schaefer@tuxinaut.de";
      signing = {
        key = "23DB861B";
        signByDefault = true;
        gpgPath = "gpg2";
      };
      extraConfig = {
        color.ui = "auto";
        merge.tool = "meld";
        core.editor = "vim";
        core.excludesfile = "~/.gitignore";
      };
    };

    programs.rofi = {
      enable = true;
      padding = 1;
      lines = 10;
      borderWidth = 1;
      location = "bottom";
      width = 100;
      xoffset = 0;
      yoffset = 0;
      colors = {
        window = {
          background = "#2f1e2e";
          border = "argb:36ef6155";
          separator = "argb:2fef6155";
        };
        rows = {
          normal = {
            background = "argb:a02f1e2e";
            foreground = "#b4b4b4";
            backgroundAlt = "argb:a02f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#ffffff";
            };
          };
          urgent = {
            background = "argb:272f1e2e";
            foreground = "#ef6155";
            backgroundAlt = "argb:2f2f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#ef6155";
            };
          };
          active = {
            background = "argb:272f1e2e";
            foreground = "#815ba4";
            backgroundAlt = "argb:2f2f1e2e";
            highlight = {
              background = "argb:54815ba4";
              foreground = "#815ba4";
            };
          };
        };
      };
      separator = "dash";
    };

    programs.autorandr = {
      enable = true;
      profiles = {
        "normal" = {
          fingerprint = {
            eDP-1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP-1.enable = false;
            DP-2.enable = false;
            VIRTUAL1.enable = false;
            eDP-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
        "dell_horizontal" = {
          fingerprint = {
            DP-1-2 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP-1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP-2.enable = false;
            VIRTUAL1.enable = false;
            DP-1-2 = {
              enable = true;
              mode = "2560x1440";
              position = "1920x0";
              rate = "59.95";
            };
            eDP-1 = {
              enable = true;
              primary = true;
              position = "0x0";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
        "dell_vertical" = {
          fingerprint = {
            DP-1-2 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP-1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP-2.enable = false;
            VIRTUAL1.enable = false;
            DP-1-2 = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
              rotate = "left";
            };
            eDP-1 = {
              enable = true;
              primary = true;
              position = "0x2560";
              mode = "1920x1080";
              rate = "59.93";
            };
          };
        };
      };
    };

    home.file = {
      ".gitignore".source = ../gitignore;
      ".config/i3/i3-exit".source = ../i3/i3-exit;
      ".i3status.conf".source = ../i3/i3status.conf;
      ".bashrc".source = ../bash/bashrc;
      "pictures/wallpaper.png".source = ../wallpaper.png;
      ".vim/spell/de.utf-8.spl".source = ../vim/spell/de.utf-8.spl;
      ".vim/spell/de.utf-8.sug".source = ../vim/spell/de.utf-8.sug;
    };

    programs.home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/release-18.09.tar.gz;
    };

    services.screen-locker = {
      enable = true;
      inactiveInterval = 5;
      lockCmd = "/home/tuxinaut/.config/i3/i3-exit lock";
    };

    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "monospace 12";
          allow_markup = "yes";
          format = "<b>%a:</b> %s\n%b";
          sort = "yes";
          indicate_hidden = "yes";
          alignment = "left";
          bounce_freq = 0;
          show_age_threshold = 60;
          word_wrap = "yes";
          ignore_newline = "no";
          geometry = "x3-0-0";
          transparency = 0;
          idle_threshold = 120;
          monitor = 0;
          follow = "keyboard";
          sticky_history = "yes";
          line_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          separator_color = "frame";
          startup_notification = "true";
          #dmenu = /usr/bin/dmenu -p dunst:;
          #browser = /usr/bin/firefox -new-tab;
        };
				frame = {
						width = 0;
						color = "#000000";
				};
				shortcuts = {
						close = "mod4+m";
						close_all = "mod4+shift+m";
						history = "mod4+n";
						context = "mod4+shift+i";
				};
				urgency_low = {
						background = "#222222";
						foreground = "#888888";
						timeout = 10;
				};
				urgency_normal = {
						background = "#285577";
						foreground = "#ffffff";
						timeout = 10;
				};
				urgency_critical = {
						background = "#900000";
						foreground = "#ffffff";
						timeout = 0;
				};
      };
    };

    services.network-manager-applet = {
      enable = true;
    };

    services.blueman-applet = {
      enable = true;
    };

    services.parcellite = {
      enable = true;
    };

    services.redshift = {
      enable = true;
      tray = true;
      latitude = "53.551086";
      longitude = "9.993682";
    };

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };
}
