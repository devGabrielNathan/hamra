# ═══════════════════════════════════════════════════════════════
# HAMRA.NIX — Configuração específica desta máquina
# ═══════════════════════════════════════════════════════════════
# Lê os dados de hosts/main/hamra.json (gerado pelo wizard)
# e mapeia para as opções do framework.
#
# Se hamra.json não existir, usa os defaults internos.
#
# Não edite este arquivo manualmente para valores de configuração.
# Use overrides.nix para customizações.
# ═══════════════════════════════════════════════════════════════
{ lib, ... }:

let
  cfgPath = ./hamra.json;
  hasConfig = builtins.pathExists cfgPath;
  cfg = if hasConfig then builtins.fromJSON (builtins.readFile cfgPath) else {
    userName = "nixos";
    hostname = "nixos";
    timezone = "America/Sao_Paulo";
    locale = "pt_BR.UTF-8";
    keymap = "us";
    gpu = "intel";
    loader = "grub";
    grubDevice = "/dev/sda";
    session = "plasma";
  };
in
{
  hamra = {
    userName = cfg.userName;
    system = {
      hostname = cfg.hostname;
      timezone = cfg.timezone;
      locale   = cfg.locale;
      keymap   = cfg.keymap;
    };
    gpu = cfg.gpu;
    boot = {
      loader = cfg.loader;
      grub.device = cfg.grubDevice;
    };
    defaultSession = cfg.session;
    sessions.${cfg.session} = true;
  };
}
