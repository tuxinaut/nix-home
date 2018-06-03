{ pkgs, lib, ... }:

let
  modifier = "Mod4";
  move = "50px";
in
{
    home.packages = [
      pkgs.htop
      pkgs.git
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
            "${modifier}+Shift+exclam" = "move workspace 1:Web";
            "${modifier}+Shift+qoutedbl" = "move workspace 2:Email";
            "${modifier}+Shift+section" = "move workspace 3:Terminal";
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

    programs.home-manager = {
      enable = true;
      path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    };
}
