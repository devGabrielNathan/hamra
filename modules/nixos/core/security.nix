# Configura sudo para autenticação do sistema.
# Polkit fica em modules/nixos/desktop/polkit.nix (ativado apenas com sessão desktop).
{ pkgs, lib, ... }:
{
  # sudo: wheel sem senha de confirmação (opcional — comentar para exigir senha)
  security.sudo.wheelNeedsPassword = lib.mkDefault true;
}
