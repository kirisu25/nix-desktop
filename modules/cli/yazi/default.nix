{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = true;
      };
    };
  };
  xdg.configFile."yazi/theme.toml".source = ./tokyonight_night.toml;

  home.packages = with pkgs; [
    jq
    jellyfin-ffmpeg
    poppler-utils
    fd
    ripgrep
    fzf
    imagemagick
    zoxide
  ];
}
