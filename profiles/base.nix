# ═══════════════════════════════════════════════════════════════
# PERFIL BASE — importa módulos de sistema comuns a todos os hosts
# ═══════════════════════════════════════════════════════════════
# Contém apenas configuração de SISTEMA (nixos modules).
# Módulos de home-manager ficam em profiles/desktop/common.nix
# pois só fazem sentido em contexto de desktop com usuário.
# ═══════════════════════════════════════════════════════════════
{ ... }:
{
  imports = [
    # API pública — deve vir primeiro
    ../modules/nixos/options/hamra.nix

    # Core: configuração presente em qualquer NixOS
    ../modules/nixos/core/boot.nix
    ../modules/nixos/core/nix.nix
    ../modules/nixos/core/locale.nix
    ../modules/nixos/core/network.nix
    ../modules/nixos/core/keyboard.nix
    ../modules/nixos/core/users.nix
    ../modules/nixos/core/security.nix
    ../modules/nixos/core/gpu.nix

    # Desktop: módulos reativos (hamra.session.*)
    ../modules/nixos/desktop/audio.nix
    ../modules/nixos/desktop/display-manager.nix
    ../modules/nixos/desktop/env.nix
    ../modules/nixos/desktop/fonts.nix
    ../modules/nixos/desktop/polkit.nix
    ../modules/nixos/desktop/portals.nix
    ../modules/nixos/desktop/printing.nix

    # Manutenção: GC automático e otimização
    ../modules/nixos/maintenance/gc.nix
  ];
}
