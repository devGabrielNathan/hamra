# ═══════════════════════════════════════════════════════════════
# APPS — pacotes do usuário disponíveis em todas as sessões
# ═══════════════════════════════════════════════════════════════
# Adicione pacotes extras em hosts/main/overrides.nix.
{ pkgs, lib, ... }:
{
  home-manager.sharedModules = [{
    home.packages = with pkgs; [
      # ── Anotações ─────────────────────────────────────────────
      obsidian

      # ── Banco de dados & API ──────────────────────────────────
      dbeaver-bin
      postman

      # ── Comunicação & Mídia ──────────────────────────────────
      discord
      obs-studio
      spotify

      # ── Desenvolvimento ───────────────────────────────────────
      git
      lazydocker
      lazygit

      # ── Diagnóstico & Monitoramento ───────────────────────────
      camunda-modeler
      wireshark

      # ── Editor ────────────────────────────────────────────────
      neovim
      vscode

      # ── IA ────────────────────────────────────────────────────
      opencode

      # ── Navegador ─────────────────────────────────────────────
      firefox

      # ── Terminal ──────────────────────────────────────────────
      kitty

      # ── TUI ───────────────────────────────────────────────────
      btop
      fastfetch
    ];

    programs.firefox.enable = lib.mkDefault true;
  }];
}
