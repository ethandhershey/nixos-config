{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;

    # 32-bit graphics support — mandatory for the vast majority of games.
    # Also enables 32-bit NVIDIA libs when the nvidia driver is loaded.
    extraCompatPackages = with pkgs; [
      # Proton-GE: community Proton build with extra game compatibility patches.
      # Run via Steam → Properties → Compatibility → Force a specific version.
      proton-ge-bin
    ];
  };

  hardware.graphics = {
    # 32-bit OpenGL/Vulkan (Steam, Wine, Proton all need this).
    enable32Bit = true;
  };

  # ── GameMode ──────────────────────────────────────────────────────────
  # Temporarily raises process priority and applies system tweaks
  # while a game is running. Launch option:  gamemoderun %command%
  #
  # Note: power-profiles-daemon (needed by noctalia's power widget) and
  # gamemode both try to manage CPU performance. Configuring gamemode to
  # explicitly request "performance" governor still works alongside PPD;
  # PPD may partially override the governor at idle, which is acceptable.
  programs.gamemode = {
    enable = true;
    # settings = {
    #   cpu.governor = "performance";
    #   general.softrealtime = "auto"; # enable SCHED_RR where possible
    #   general.renice = 10;           # lower nice value for game process
    # };
  };

  # ── Gamescope ─────────────────────────────────────────────────────────
  # Valve's micro-compositor for per-game resolution/refresh/FSR.
  # capSysNice = true allows gamescope to use setpriority() so it can
  # give the game process a lower nice value for better scheduling.
  # Steam launch option:  gamescope -W 1920 -H 1080 -f -- %command%
  programs.gamescope = {
    enable = true;
    # capSysNice = true;
  };

  # ── Controller support ────────────────────────────────────────────────
  # udev rules for Xbox, PlayStation, Steam, and generic controllers.
  hardware.steam-hardware.enable = true;
}
