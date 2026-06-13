# Configura o shell do usuário: zsh com aliases, variáveis e prompt via Starship.
{ pkgs, ... }: {
  home-manager.sharedModules = [{
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        ll    = "ls -la";
        la    = "ls -A";
        ".."  = "cd ..";
        "..." = "cd ../..";
      };
    };

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
    };
  }];
}
