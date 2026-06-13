# hamra

Configuração NixOS modular com suporte a múltiplos desktop environments. Cada sessão é construída apenas quando ativada.

## Sessões disponíveis

| Sessão | Opção | WM / DE | DM |
|--------|-------|---------|----|
| BSPWM + gh0stzk | `sessions.bspwm` | bspwm (X11) | SDDM |
| KDE Plasma 6 | `sessions.plasma` | KWin (Wayland) | SDDM |
| GNOME | `sessions.gnome` | Mutter (Wayland/X11) | SDDM |
| Recovery | `sessions.recovery` | TTY (sem gráfico) | — |

---

## Início rápido

> [!IMPORTANT]
> Em instaladores mínimos sem `git`, entre em um shell temporário antes de clonar:
> ```bash
> nix-shell -p git gum
> ```
>
> O wizard usa [`gum`](https://github.com/charmbracelet/gum) para uma experiência interativa. Se não estiver disponível, funciona com entrada de texto padrão.

> [!WARNING]
> **Sobre o `/etc/nixos` existente**: o script faz backup automático para `/etc/nixos.bak` e extrai dados como hostname, locale e partições antes de sobrescrever.

```bash
nix-shell -p git gum
git clone https://github.com/devGabrielNathan/conf ~/hamra
cd ~/hamra
sudo bash scripts/hamra-init.sh
cd /etc/nixos
sudo nixos-rebuild switch --flake .#main
sudo reboot
```

---

## Trocando de sessão

Todas as sessões são `false` por padrão. Edite `hosts/main/overrides.nix`:

```nix
{ config, pkgs, lib, ... }: {
  hamra = {
    sessions.gnome    = true;
    defaultSession    = "gnome";
  };
}
```

```bash
sudo nixos-rebuild switch --flake .#main
```

> Recovery desabilita o display manager e o Home Manager.

---

## Configuração

### Dados da máquina — `hosts/main/hamra-config.nix`

Gerado pelo `hamra-init.sh`, este módulo Nix centraliza os valores da máquina:

```nix
{ lib, ... }: {
  hamra = {
    userName = "gabrielnathan";
    system = {
      hostname = "nixos";
      timezone = "America/Sao_Paulo";
      locale   = "pt_BR.UTF-8";
      keymap   = "us";
    };
    gpu = "intel";
    boot = {
      loader = "grub";
      grub.device = "/dev/sda";
    };
    defaultSession = "bspwm";
    sessions.bspwm = true;
  };
}
```

Para regenerar: `sudo bash scripts/hamra-init.sh`

### Personalizações — `hosts/main/overrides.nix`

Nunca alterado pelo wizard:

```nix
{ config, pkgs, lib, ... }: {
  hamra = {
    userName = "gabrielnathan";
    system.hostname = "workstation";
    gpu = "nvidia";
    sessions.plasma = true;
    defaultSession  = "plasma";
  };
  environment.systemPackages = with pkgs; [ vscode discord ];
}
```

### Referência rápida

| O que fazer | Onde editar |
|-------------|-------------|
| Hostname, timezone, locale, teclado | `hosts/main/overrides.nix` ou `hosts/main/hamra-config.nix` |
| Driver de GPU | `overrides.nix` → `hamra.gpu` |
| Sessão ativa | `overrides.nix` → `hamra.sessions.*` |
| Sessão padrão | `overrides.nix` → `hamra.defaultSession` |
| Pacotes extras | `overrides.nix` |
| Apps para todas as sessões | `modules/home/common/apps.nix` |
| SDDM / tema do login | `modules/nixos/desktop/display-manager.nix` |
| Fontes | `modules/nixos/desktop/fonts.nix` |
| Áudio | `modules/nixos/desktop/audio.nix` |

---

## Estrutura

```
hamra/
├── flake.nix
├── hosts/main/
│   ├── default.nix
│   ├── hamra.nix                  # Importa hamra-config.nix → opções hamra.*
│   ├── hamra-config.nix           # Gerado pelo wizard
│   ├── hardware-configuration.nix # Gerado por nixos-generate-config
│   └── overrides.nix              # Suas customizações (nunca sobrescrito)
├── profiles/
│   ├── base.nix
│   ├── recovery.nix
│   └── desktop/
│       ├── common.nix
│       ├── bspwm.nix
│       ├── gnome.nix
│       └── plasma.nix
├── modules/
│   ├── nixos/
│   │   ├── options/hamra.nix
│   │   ├── core/       (boot, locale, network, keyboard, users, security)
│   │   ├── desktop/    (audio, dm, env, fonts, gpu, polkit, portals, printing)
│   │   ├── sessions/   (bspwm, gnome, plasma)
│   │   └── maintenance/gc.nix
│   └── home/
│       ├── common/     (shell, git, terminal, apps)
│       └── gh0stzk/
├── scripts/
│   ├── hamra-init.sh               # Orquestrador (4 fases)
│   └── lib/
│       ├── log.sh                  # Logging com suporte a gum
│       ├── setup.sh                # Prepara /etc/nixos + git
│       ├── detect.sh               # Descobre config existente + GPU + hardware
│       ├── wizard.sh               # Assistente interativo
│       └── generate.sh             # Gera hamra-config.nix + define senha
└── docs/
```

---

## Documentação

- [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md)
- [`docs/ADRs.md`](docs/ADRs.md)
- [`docs/PRD.md`](docs/PRD.md)
- [`docs/REQUISITOS.md`](docs/REQUISITOS.md)
- [`docs/USER_STORIES.md`](docs/USER_STORIES.md)
- [`docs/STYLE_GUIDE.md`](docs/STYLE_GUIDE.md)
- [`docs/GUIA_IA.md`](docs/GUIA_IA.md)
