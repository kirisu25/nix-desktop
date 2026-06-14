{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zellij
  ];

  home.file = {
    "./config/zellij/config.kdl" = {
      target = ".config/zellij/config.kdl";
      source = ./config.kdl;
    };

    ".config/zellij/themes/tokyonight-moon.kdl" = {
      target = ".config/zellij/themes/tokyonight-moon.kdl";
      source = ./theme.kdl;
    };
  };
}
