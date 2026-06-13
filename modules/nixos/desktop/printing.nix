# Impressão (CUPS) — habilitado conforme hamra.session.printing.
{ config, lib, ... }:

let
  cfg = config.hamra.session;
in
lib.mkIf cfg.printing {
  services.printing.enable = true;
}
