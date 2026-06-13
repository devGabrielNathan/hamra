{ config, lib, ... }:

let
  cfg = config.hamra;
in
lib.mkIf cfg.sessions.plasma {
  hamra.session = {
    displayManager = lib.mkDefault "sddm";
    compositor     = lib.mkDefault "wayland";
    portals        = lib.mkDefault "kde";
    fonts          = lib.mkDefault "default";
    env = {
      editor   = lib.mkDefault "nvim";
      browser  = lib.mkDefault "firefox";
      terminal = lib.mkDefault "konsole";
    };

  services.desktopManager.plasma6.enable = true;
}
