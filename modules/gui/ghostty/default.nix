{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ghostty
  ];

  
  home.file ={
    ".config/ghostty/config" = {
      target = ".config/ghostty/config";
      source = ./config;
    };
  };
}
