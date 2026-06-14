{ pkgs, ... }:
{
  home = rec {
    username = "kirisu25";
    homeDirectory = "/home/${username}";
    stateVersion = "24.11";
  };
  programs.home-manager.enable = true;

  imports = [
    ./modules/hyprland
    ./modules/cli
    ./modules/gui
  ];
}
