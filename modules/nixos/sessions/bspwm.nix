{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.hamra;
in
lib.mkIf cfg.sessions.bspwm {
  imports = [
    inputs.silentSDDM.nixosModules.default
  ];

  hamra.session = {
    displayManager = lib.mkDefault "sddm";
    sddmTheme      = lib.mkDefault "silent";
    compositor     = lib.mkDefault "x11";
    printing       = lib.mkDefault true;
    fonts          = lib.mkDefault "nerd";
    env = {
      editor    = lib.mkDefault "nvim";
      browser   = lib.mkDefault "firefox";
      terminal  = lib.mkDefault "kitty";
    };
  };

  programs.silentSDDM = {
    enable = true;
    theme  = "rei";
  };

  services.xserver = {
    enable = true;
    layout = cfg.system.keymap;
    libinput.enable = true;
    windowManager.bspwm = {
      enable = true;
      configFile = null;
      sxhkd.configFile = null;
    };
  };

  hardware.opengl.enable = true;
  programs.dconf.enable = true;

  users.users.${cfg.userName}.shell = pkgs.zsh;
}
