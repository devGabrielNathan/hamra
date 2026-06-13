# ═══════════════════════════════════════════════════════════════
# PERFIL DESKTOP COMUM — módulos compartilhados entre sessões
# ═══════════════════════════════════════════════════════════════
# Importado por todos os perfis de desktop antes dos módulos
# específicos de cada sessão.
#
# O que NÃO está aqui (cada sessão opta):
#   - shell.nix    → gh0stzk usa .zshrc próprio
#   - terminal.nix → gh0stzk usa temas próprios
# ═══════════════════════════════════════════════════════════════
{ ... }:
{
  imports = [
    ../../modules/home/common/git.nix
    ../../modules/home/common/apps.nix
  ];
}
