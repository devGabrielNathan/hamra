# hamra

Configuração NixOS modular com suporte a múltiplos desktop environments. Cada sessão é ativada via specialisation.

## Sessões disponíveis

| Sessão | Opção | WM / DE | DM |
|--------|-------|---------|----|
| Hyprland + omarchy | `sessions.hyprland` | Hyprland (Wayland) | SDDM |
| KDE Plasma 6 | `sessions.plasma` | KWin (Wayland) | SDDM |
| GNOME | `sessions.gnome` | Mutter (Wayland) | GDM |

Cada sessão importa apenas os módulos desktop que precisa, mantendo o sistema enxuto.

---

## Início rápido

> [!IMPORTANT]
> Em instaladores mínimos sem `git`, entre em um shell temporário antes de clonar:
> ```bash
> nix-shell -p git gum
> ```
>
> O wizard usa [`gum`](https://github.com/charmbracelet/gum) para uma experiência interativa.

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

## Temas

22 temas omarchy, sendo 9 com suporte base16 via nix-colors:

| Tema | base16 | wallpaper |
|------|--------|-----------|
| `catppuccin` / `catppuccin-macchiato` | `catppuccin-macchiato` | `catppuccin-totoro.png` |
| `everforest` | `everforest` | `everforest-tree-tops.jpg` |
| `gruvbox` / `gruvbox-light` | `gruvbox-dark-hard` / `gruvbox-light-medium` | `gruvbox-the-backwater.jpg` |
| `kanagawa` | `kanagawa` | `kanagawa-kanagawa.jpg` |
| `nord` | `nord` | `nord-black-moon.jpg` |
| `tokyo-night` | `tokyo-night-dark` | `tokyo-night-swirl-buck.jpg` |
| `generated_light` / `generated_dark` | extraído do wallpaper | configurado via `theme_overrides` |

As cores base16 são aplicadas a todos os apps: waybar, wofi, mako, ghostty, hyprlock, btop.

Temas omarchy sem equivalente base16 fazem fallback para catppuccin.

---

## Trocando de sessão

Edite `hosts/main/overrides.nix`:

```nix
{ config, pkgs, lib, ... }: {
  hamra = {
    sessions.hyprland = true;
    defaultSession    = "hyprland";
  };
}
```

```bash
sudo nixos-rebuild switch --flake .#main
```

---

## Configuração

### Dados da máquina — `hosts/main/hamra-config.nix`

Gerado pelo `hamra-init.sh`:

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
    defaultSession = "hyprland";
    sessions.hyprland = true;
  };
}
```

### Serviços comuns — `modules/nixos/core/users.nix`

O que você quer em toda máquina sua: docker, bluetooth, direnv, zsh, wireshark, etc.

### Personalizações — `hosts/main/overrides.nix`

Nunca alterado pelo wizard — apenas específico deste host.

### Temas — `modules/nixos/options/omarchy.nix`

Opções: `theme`, `theme_overrides`, `wallpaper_path`, `monitors`, `scale`, `primary_font`, `quick_app_bindings`, `exclude_packages`, `vscode_settings`.

---

## Estrutura

```
hamra/
├── flake.nix                        # inputs + nixosConfigurations.main + devShell
├── hosts/main/
│   ├── default.nix                  # Machine config + specialisations
│   ├── hamra.nix                    # Importa hamra-config.nix
│   ├── hamra-config.nix             # Gerado pelo wizard
│   ├── hardware-configuration.nix   # Gerado por nixos-generate-config
│   └── overrides.nix               # Suas customizações (nunca sobrescrito)
├── profiles/
│   ├── base.nix                     # Core + options + GC
│   └── desktop/
│       ├── common.nix               # shell + git + apps (todas as sessões)
│       ├── hyprland.nix             # base + common + hyprland session + home
│       ├── gnome.nix
│       └── plasma.nix
├── modules/
│   ├── nixos/
│   │   ├── options/hamra.nix        # hamra.* (system, user, sessions, fonts, env)
│   │   ├── options/omarchy.nix      # omarchy.* (theme, monitors, bindings, etc)
│   │   ├── core/                    # boot, nix, locale, network, keyboard, users, security, gpu
│   │   ├── desktop/                 # audio, display-manager, env, fonts, gtk, polkit, portals, printing
│   │   ├── sessions/               # hyprland, plasma, gnome (cada um importa só o que precisa)
│   │   ├── services/               # 1password
│   │   └── maintenance/gc.nix
│   └── home/
│       ├── common/                  # shell (zsh+starship+zoxide+direnv), git, apps, terminal
│       └── hyprland/                # hypr/, waybar/, wofi/, mako/, ghostty/,
│                                    # hyprlock/, hyprpaper/, btop/, vscode/,
│                                    # themes/, packages/, wallpapers/, bin/, scripts/
├── lib/
│   ├── default.nix
│   ├── mkSpecialisation.nix
│   └── selected-wallpaper.nix       # Resolve wallpaper por tema
├── scripts/
│   └── hamra-init.sh + lib/         # Wizard interativo de setup
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
