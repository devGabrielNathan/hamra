# Fontes do sistema conforme hamra.session.fonts.
{ pkgs, config, lib, ... }:

let
  cfg  = config.hamra.session;
  nerd = cfg.fonts == "nerd";
in
{
  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
    ] ++ lib.optionals nerd [
      nerd-fonts.jetbrains-mono
    ];

    fontconfig.defaultFonts = {
      serif     = [ "Liberation Serif" "Noto Serif" ];
      sansSerif = [ "Liberation Sans"  "Noto Sans" ];
      monospace = if nerd then [ "JetBrainsMono Nerd Font" ] else [ "Liberation Mono" "Noto Mono" ];
      emoji     = [ "Noto Color Emoji" ];
    };
  };
}
