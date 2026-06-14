{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm.lua;
  };

  home.file ={
    ".config/wezterm/keybinds.lua" = {
      target = ".config/wezterm/keybinds.lua";
      source = ./keybinds.lua;
    };
  };
}
