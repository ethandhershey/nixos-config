# nixos-config

My personal NixOS configuration, managed with flakes and home-manager.

## Structure

```
flake.nix          # Entrypoint, defines hosts and shared user variables
modules/
  common.nix       # Shared config across all hosts
  graphical.nix    # Wayland/niri desktop environment
  server.nix       # Server-specific config
  ...              # Other modules
hosts/
  matcha/          # Desktop (NVIDIA, CachyOS kernel)
  framework/       # Laptop (Framework)
  homelab/         # Home server
config/            # Static config files
```

## Usage

Rebuild the current host:

```sh
sudo nixos-rebuild switch --flake .#<host>
```
