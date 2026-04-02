{ pkgs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/server.nix
  ];

  networking.hostName = "homelab";

  users.users.${user.name} = {
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 CHANGEME ethan@desktop"
    ];
  };

  home-manager.users.${user.name} = {
    home.username = user.name;
    home.homeDirectory = "/home/${user.name}";
    home.stateVersion = "25.05";

    services.podman = {
      enable = true;
      # container stacks go here
    };
  };

  system.stateVersion = "25.05";
}
