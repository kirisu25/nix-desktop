# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  ...
}:
let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = "x86_64-linux";
    config.allowUnfree = true;
  };
in
{
  imports = [
    ./hardware-configuration.nix
  ]
  ++ (with inputs.nixos-hardware.nixosModules; [
    common-pc-ssd
    common-cpu-amd
    common-gpu-amd
  ]);

  system.stateVersion = "24.05"; # Did you read the comment?

  # kernel
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Enable microcode update
  hardware.cpu.amd.updateMicrocode = true;

  # gup
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable firmware for amdgpu, etc.
  # This is necessary to avoid errors like "Trying to push to a killed entity".
  hardware.enableRedistributableFirmware = true;

  # Load amdgpu driver for Xorg & Wayland
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.hostName = "deskt"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = [
      pkgs.fcitx5-mozc
      pkgs.fcitx5-gtk
    ];
    fcitx5.waylandFrontend = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts-cjk-serif
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.noto
    nerd-fonts.jetbrains-mono
    hackgen-nf-font
  ];

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "Noto Serif CJK JP"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Noto Sans CJK JP"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    wireplumber = {
      enable = true;
      package = pkgs.wireplumber;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kirisu25 = {
    isNormalUser = true;
    description = "kirisu25";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  programs = {
    git = {
      enable = true;
    };

    starship = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };

    firefox = {
      enable = true;
    };

    nix-ld.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  # font override to steam
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs =
        pkgs: with pkgs; [
          migu
        ];
    };
  };

  environment.systemPackages = with pkgs; [
    helix
    kitty
    wofi
    pavucontrol
    amdgpu_top
    bottom
    mako
    uwsm
    waybar
    swww
  ];

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.loginSHellInit = ''
    if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
          exec uwsm start hyprland-uwsm.desktop
        fi

  '';

  xdg.portal.enable = true;

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.kirisu25 = import ./home.nix;
}
