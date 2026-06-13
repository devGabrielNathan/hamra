# XDG Desktop Portals conforme hamra.session.portals.
{ config, pkgs, lib, ... }:

let
  cfg = config.hamra.session;
  portal = with pkgs;
    if      cfg.portals == "gtk" then xdg-desktop-portal-gtk
    else if cfg.portals == "kde" then xdg-desktop-portal-kde
    else    null;
in
lib.mkIf (cfg.portals != "none") {
  xdg.portal = {
    enable = true;
    extraPortals = [ portal ];
  };
}
