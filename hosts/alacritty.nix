{
programs.alacritty = {
  enable = true;
  settings = {
    env = {
      TERM = "xterm-256color";
    };
    font = {
      normal.family = "Hack";
    };
    selection = {
      save_to_clipboard = true;
    };
    window = {
      dynamic_title = true;
      opacity = 0.9;
    };
    scrolling = {
      history = 50000;
    };
    keyboard.bindings = [
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
}
