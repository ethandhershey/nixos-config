{
  pkgs,
  inputs,
  config,
  user,
  ...
}:
let
  llama-cpp =
    (pkgs.llama-cpp.overrideAttrs (attrs: rec {
      version = "8981";
      src = pkgs.fetchFromGitHub {
        owner = "ggml-org";
        repo = "llama.cpp";
        tag = "b${version}";
        hash = "sha256-ansKERDwPFzJYkJmeNwSXFcyi1e9T+s8gbdV3ecyD6Q=";
      };
      # npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
      # postPatch =
      #   builtins.replaceStrings
      #     [ "rm tools/server/public/index.html.gz" ]
      #     [ "rm -f tools/server/public/index.html.gz" ]
      #     (attrs.postPatch or "");
      cmakeFlags = (attrs.cmakeFlags or [ ]) ++ [
        "-DGGML_NATIVE=ON"
      ];
    })).override
      {
        cudaSupport = true;
        blasSupport = true;
      };
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/steam.nix
    ../../modules/graphical.nix
  ];
  networking.hostName = "matcha";
  users.users.${user.name} = {
    extraGroups = [ "gamemode" ];
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 CHANGEME ethan@desktop"
    ];
  };
  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.default ];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
  nix.settings = {
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };
  nixpkgs.config.allowUnfree = true;
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  environment.sessionVariables = {
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBVA_DRIVER_NAME = "nvidia";
  };
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      gcc.cc.lib
      zlib
      openssl
      libffi
      glib
      libGL
      libcap_ng
    ];
  };

  home-manager.users.${user.name} = {
    home.username = user.name;
    home.homeDirectory = "/home/${user.name}";
    home.stateVersion = "25.05";
    home.packages = with pkgs; [
      nil
      nixd
      alejandra
      nodejs_22
      llama-cpp
      rtk
      uv
      ruff
      ty
      opencode
      codex
    ];
  };
  system.stateVersion = "25.05";
}
