{ pkgs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/graphical.nix
  ];

  networking.hostName = "framework";

  users.users.${user.name} = {
    extraGroups = [ ];
  };

  services.tlp.enable = true;
  services.fwupd.enable = true;
  services.logind.lidSwitch = "suspend";

  home-manager.users.${user.name} = {
    home.username = user.name;
    home.homeDirectory = "/home/${user.name}";
    home.stateVersion = "25.05";
  };

  system.stateVersion = "25.05";
}
