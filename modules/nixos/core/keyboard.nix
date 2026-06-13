# Configura o layout de teclado para console e sessões via hamra.system.keymap.
{ config, lib, ... }:

let
  cfg = config.hamra;
in
{
  console.keyMap = lib.mkDefault cfg.system.keymap;

  # Layout de teclado para SDDM e sessões X11 (XKB)
  services.xserver.xkb = {
    layout  = lib.mkDefault cfg.system.keymap;
    variant = lib.mkDefault cfg.system.xkbVariant;
  };
}
