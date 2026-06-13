{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../base.nix
    ./common.nix
    ../../modules/nixos/sessions/bspwm.nix
  ];

  home-manager.users.${config.hamra.userName}.imports = [
    ../../modules/home/gh0stzk/default.nix
  ];
}
