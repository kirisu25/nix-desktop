{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vscode
    thunar
    zed-editor
    emacs
  ];
}
