{
  pkgs,
  inputs,
  user,
  ...
}:
{
  users.users.${user.name} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "netbird-wt0"
    ];
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 CHANGEME ethan@desktop"
    ];
  };

  # --- system ---
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    git
    htop
    wget
    curl
    fastfetch
    inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs = {
    fish.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.netbird.clients.wt0 = {
    environment = {
      NB_MANAGEMENT_URL = "https://netbird.ethanhershey.com";
      NB_ADMIN_URL = "https://netbird.ethanhershey.com";
    };

    # Port used to listen to wireguard connections
    port = 51821;

    # Set this to true if you want the GUI client
    ui.enable = false;

    # This opens ports required for direct connection without a relay
    openFirewall = true;

    # This opens necessary firewall ports in the Netbird client's network interface
    openInternalFirewall = true;
  };

  services.resolved.enable = true;

  # --- home-manager ---
  home-manager.sharedModules = [
    {
      home.sessionPath = [ "$HOME/.cargo/bin" ];

      home.packages = with pkgs; [
        eza
        bat
        ripgrep
        fd
        jq
        bottom
        just
      ];

      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "mauve";
      };

      programs.starship.enable = true;

      programs.fish = {
        enable = true;
        shellAbbrs = {
          ls = "eza";
          ll = "eza -lh";
          la = "eza -lha";
          cat = "bat";
          rg = "rg --smart-case";
        };
        interactiveShellInit = "set fish_greeting";
      };

      programs.bat.enable = true;

      programs.git = {
        enable = true;
        settings = {
          user.name = user.gitName;
          user.email = user.gitEmail;
        };
      };
    }
  ];
}
