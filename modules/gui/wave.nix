{ pkgs, ... }:
{
  home.packages = with pkgs; [
    waveterm
  ];
}
