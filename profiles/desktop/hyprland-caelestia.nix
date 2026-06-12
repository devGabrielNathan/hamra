{ config, lib, inputs, ... }:
{
  imports = [
    ../base.nix
    ./common.nix
    ../../modules/nixos/sessions/hyprland.nix
  ];

  home-manager.users.${config.hamra.userName}.imports = [
    inputs.caelestia-shell.homeManagerModules.default
    inputs.hyprland.homeManagerModules.default
    ../../modules/home/caelestia/default.nix
  ];
}
