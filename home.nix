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

    programs.home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
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
