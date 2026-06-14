{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    ghq
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "kirisu25";
      user.email = "kirisu25@gmail.com";
      core.editor = "nvim";
      color = {
        status = "auto";
        diff = "auto";
        branch = "auto";
        interactive = "auto";
        grep = "auto";
      };
      init.DefaultBranch = "main";
      ghq.root = "${config.home.homeDirectory}/src";
    };
  };

  programs.gh = {
    enable = true;
  };
}
