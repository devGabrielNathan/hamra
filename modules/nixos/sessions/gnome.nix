{ config, lib, pkgs, ... }:

let
  cfg = config.hamra;
in
lib.mkIf cfg.sessions.gnome {
  hamra.session = {
    displayManager = lib.mkDefault "gdm";
    compositor     = lib.mkDefault "wayland";
    portals        = lib.mkDefault "gtk";
    fonts          = lib.mkDefault "default";
    env = {
      editor   = lib.mkDefault "nvim";
      browser  = lib.mkDefault "epiphany";
      terminal = lib.mkDefault "gnome-terminal";
    };

  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
  ];
}
