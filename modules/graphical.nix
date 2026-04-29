{
  pkgs,
  inputs,
  user,
  ...
}:
{
  imports = [
    ./common.nix
    inputs.catppuccin.nixosModules.catppuccin
  ];

  users.users.${user.name} = {
    extraGroups = [
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };

  # --- system ---
  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  programs.niri.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  security.polkit.enable = true;
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
  # services.gnome.gnome-keyring.enable = true;
  # security.pam.services.swaylock = {};

  programs.dconf.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  # --- home-manager ---
  home-manager.sharedModules = [
    inputs.noctalia.homeModules.default
    (
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          mission-center
          nautilus
          # oculante
          sniffnet
        ];

        services.easyeffects.enable = true;

        programs.alacritty = {
          enable = true;
          settings = {
            terminal.shell.program = "${pkgs.fish}/bin/fish";
            window = {
              padding = {
                x = 8;
                y = 8;
              };
              decorations = "None";
              dynamic_title = true;
              # opacity = 0.95;
            };
            font = {
              normal = {
                family = "JetBrainsMono Nerd Font";
                style = "Regular";
              };
              bold = {
                family = "JetBrainsMono Nerd Font";
                style = "Bold";
              };
              italic = {
                family = "JetBrainsMono Nerd Font";
                style = "Italic";
              };
              size = 13.0;
            };
            cursor.style = {
              shape = "Block";
              blinking = "On";
            };
            scrolling.history = 10000;
          };
        };

        programs.zed-editor = {
          enable = true;
          package = pkgs.zed-editor;
        };

        programs.chromium = {
          enable = true;
          package = pkgs.brave;
          extensions = [
            # { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
          ];
        };

        programs.noctalia-shell = {
          enable = true;
        };
        services.cliphist.enable = true;

        xdg.configFile."noctalia/settings.json".source = "${inputs.self}/config/noctalia/settings.json";
        xdg.configFile."niri/config.kdl".source = "${inputs.self}/config/niri/config.kdl";

        home.pointerCursor = {
          enable = true;
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 22;
        };
      }
    )
  ];
}
