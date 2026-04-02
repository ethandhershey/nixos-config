{ ... }: {
  imports = [ ./common.nix ];

  users.users.ethan = {
    extraGroups = [ "podman" ];
    linger = true;
    autoSubUidGidRange = true;
  };

  # --- system ---
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;

  hardware.pulseaudio.enable = false;
  services.pipewire.enable = false;

  # --- home-manager ---
  # containers are defined per-host in home-manager.users.ethan
  # since each host has different stacks
}
