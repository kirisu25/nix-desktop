{
  inputs,
  pkgs,
  config,
  ...
}:
{

  imports = [
    ./waybar
    ./wofi
    ./mako
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    configType = "hyprlang";
  };

  xdg.configFile = {
    "hypr/hyprland.conf".source =
      config.lib.file.mkOutOfStoreSymlink "/home/kirisu25/nix-desktop/modules/hyprland/hyprland.conf";
  };

  systemd.user.services = {

    fcitx5-daemon = {
      Unit = {
        Description = "Fcitx5 Input Method Daemon";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.fcitx5}/bin/fcitx5";
        Restart = "on-failure";
      };
    };

    waybar = {
      Unit = {
        Description = "Waybar status bar";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        # wantedBy = [ "wayland-session@hyprland-uwsm.target" ];
        # partOf = [ "wayland-session@hyprland-uwsm.target" ];
        # after = [ "wayland-session@hyprland-uwsm.target" ];
      };
      Service = {
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.waybar}/bin/waybar";
        Restart = "on-failure";
      };
    };

    swww-daemon = {
      Unit = {
        Description = "Swww wallpaper daemon and setter";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        # wantedBy = [ "wayland-session@hyprland-uwsm.target" ];
        # partOf = [ "wayland-session@hyprland-uwsm.target" ];
        # after = [ "wayland-session@hyprland-uwsm.target" ];
      };
      Service = {
        Path = [
          pkgs.awww
          pkgs.coreutils
        ];
        ExecStart = "${pkgs.uwsm}/bin/uwsm app -- ${pkgs.awww}/bin/awww-daemon";
        ExecStartPost = "${pkgs.coreutils}/bin/sleep 0.5; ${pkgs.uwsm}/bin/uwsm app -- ${pkgs.awww}/bin/awww img -a /home/kirisu25/.config/hypr/wallpaper/paper.jpg";
        Restart = "on-failure";
      };
    };
  };

  home.packages =
    (with pkgs; [
      awww
      wl-clipboard
      cliphist
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
