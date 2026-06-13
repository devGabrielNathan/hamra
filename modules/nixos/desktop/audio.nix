# Áudio — pipewire, pulseaudio ou none conforme hamra.session.audio.
{ config, lib, pkgs, ... }:

let
  cfg = config.hamra.session;
in
lib.mkIf (cfg.audio != "none") {
  security.rtkit.enable = lib.mkDefault true;

  services.pipewire = lib.mkIf (cfg.audio == "pipewire") {
    enable             = true;
    alsa.enable        = true;
    alsa.support32Bit  = true;
    pulse.enable       = true;
    wireplumber.enable = true;
  };

  services.pulseaudio = lib.mkIf (cfg.audio == "pulseaudio") {
    enable = true;
  };
}
