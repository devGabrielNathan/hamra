{ lib, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Pacotes não-livres habilitados por padrão (Obsidian, Spotify, nvidia, etc.)
  nixpkgs.config.allowUnfree = lib.mkDefault true;
}
