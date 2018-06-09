{ pkgs, lib, ... }:

let
  modifier = "Mod4";
  move = "50px";
in
{
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
    ];

    xsession.windowManager.i3 = {
      enable = true;
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
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP1.enable = false;
            DP2.enable = false;
            VIRTUAL1.enable = false;
            eDP1 = {
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
            DP1 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP2.enable = false;
            VIRTUAL1.enable = false;
            DP1 = {
              enable = true;
              mode = "2560x1440";
              position = "1920x0";
              rate = "59.95";
            };
            eDP1 = {
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
            DP1 = "00ffffffffffff0010ac6ed04c58313014190104a5371f783e4455a9554d9d260f5054a54b00b300d100714fa9408180778001010101565e00a0a0a029503020350029372100001a000000ff0039583256593535423031584c0a000000fc0044454c4c205532353135480a20000000fd0038561e711e010a202020202020018302031cf14f1005040302071601141f12132021222309070783010000023a801871382d40582c450029372100001e011d8018711c1620582c250029372100009e011d007251d01e206e28550029372100001e8c0ad08a20e02d10103e9600293721000018483f00ca808030401a50130029372100001e00000000000000000057";
            eDP1 = "00ffffffffffff004d1049140000000020190104a51d11780ede50a3544c99260f5054000000010101010101010101010101010101011a3680a070381f403020350026a510000018000000100000000000000000000000000000000000fe00444a435036804c513133334d31000000000002410328001200000b010a20200066";
          };
          config = {
            DP2.enable = false;
            VIRTUAL1.enable = false;
            DP1 = {
              enable = true;
              mode = "2560x1440";
              position = "0x0";
              rate = "59.95";
              rotate = "left";
            };
            eDP1 = {
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

    programs.home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
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
    };
}
