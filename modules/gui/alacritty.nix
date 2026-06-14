{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zellij
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          x = 4;
          y = 2;
        };
        opacity = 0.75;
        blur = true;
      };
      scrolling = {
        history = 100000;
        multiplier = 5;
      };
      font = {
        size = 14;
        normal = {
          family = "HackGen Console NF";
          style = "Regular";
        };
        bold = {
          family = "HackGen Console NF";
          style = "Bold";
        };
        italic = {
          family = "HackGen Console NF";
          style = "Italic";
        };
        bold_italic = {
          family = "HackGen Console NF";
          style = "Bold Italic";
        };
      };
      colors = {
        primary = {
          background = "#222436";
          foreground = "#c8d3f5";
        };
        normal = {
          black = "#1b1d2b";
          red = "#ff757f";
          green = "#c3e88d";
          yellow = "#ffc777";
          blue = "#82aaff";
          magenta = "#c099ff";
          cyan = "#86e1fc";
          white = "#828bb8";
        };
        bright = {
          black = "#444a73";
          red = "#ff8d94";
          green = "#c7fb6d";
          yellow = "#ffd8ab";
          blue = "#9ab8ff";
          magenta = "#caabff";
          cyan = "#b2ebff";
          white = "#c8d3f5";
        };
        # indexed_colors = {
        #   index = 16;
        #   color = "#ff966c";
        # };
      };
    };
  };

  # home.file = {
  #   #   ".config/alacritty/alacritty.toml" = {
  #   #     target = ".config/alacritty/alacritty.toml";
  #   #     source = ./alacritty.toml;
  #   #   };

  #   ".config/alacritty/theme.toml" = {
  #     target = ".config/alacritty/theme.toml";
  #     source = ./theme.toml;
  #   };
  # };
}
