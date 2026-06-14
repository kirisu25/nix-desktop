{ pkgs, ... }:
let
  waybar-date = pkgs.writeScriptBin "waybar-date" ''
    date +"%y/%m/%d:%a"
  '';

in
# waybar-wtr = pkgs.poetry2nix.mkPoetryApplication {
#   profectDir = ./scripts/.;
# };
{
  home.packages = with pkgs; [
    waybar
    waybar-date
    # waybar-wtr
  ];

  xdg.configFile."waybar/config".source = ./config;
  xdg.configFile."waybar/style.css".source = ./style.css;

}
