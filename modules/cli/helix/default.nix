{ pkgs, ... }:
{
  programs.helix = {
    enable = true;
    #defaultEditor = true;
  };
  xdg.configFile."helix/config.toml".source = ./config.toml;
  xdg.configFile."helix/languages.toml".source = ./languages.toml;
  xdg.configFile."helix/ignore".source = ./ignore;

  home.packages = with pkgs; [
    nixfmt-rfc-style
    gopls
    nil
    ruff
  ];
}
