{ inputs, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
  };

  xdg.configFile = {
    "hypr/hyprland.conf".source = ./hyprland.conf;
  };

  systemd.user.services = {

    fcitx5-daemon = {
      Unit = {
        Description = "Fcitx5 Input Method Daemon";
        WantedBy = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.fcitx5}/bin/fcitx5";
        Restart = "on-failure";
      };
    };

    waybar = {
      Unit = {
        Description = "Waybar status bar";
        WantedBy = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
    };

    swww-daemon = {
      Unit = {
        Description = "Swww wallpaper daemon and setter";
        WantedBy = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        Path = [
          pkgs.swww
          pkgs.coreutils
        ];
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.swww}/bin/swww-daemon";
        ExecStartPost = "${pkgs.coreutils}/bin/sleep 0.5; ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.swww}/bin/swww img -a /home/kirisu25/.config/hypr/wallpaper/paper.jpg";
        Restart = "on-failure";
      };
    };

  };

  home.packages =
    (with pkgs; [
      swww
      wl-clipboard
      wlogout
      wireplumber
      gtk3
      networkmanagerapplet
      hyprcursor
      nordzy-icon-theme
      nordzy-cursor-theme
    ])
    ++ [
      inputs.hyprsome.packages.${pkgs.system}.default # workspace manager
    ];

  home.file = {
    "paper.jpg" = {
      target = ".config/hypr/wallpaper/paper.jpg";
      source = ./images/paper.jpg;
    };
  };
}
