# hamra

Configuração NixOS modular com suporte a múltiplos desktop environments via `specialisations`. Cada sessão é construída apenas quando ativada.

## Sessões disponíveis

| Sessão | Opção | WM / DE | DM |
|--------|-------|---------|----|
| Niri | `sessions.niri` | Niri (scrollable-tiling) | SDDM |
| Hyprland + Caelestia Shell | `sessions.hyprland-caelestia` | Hyprland (dinâmico) | SDDM |
| KDE Plasma 6 | `sessions.plasma` | KWin (Wayland) | SDDM |
| GNOME | `sessions.gnome` | Mutter (Wayland/X11) | SDDM |
| Recovery | `sessions.recovery` | TTY (sem gráfico) | — |

---

## Início rápido

> [!IMPORTANT]
> Em instaladores mínimos sem `git`, entre em um shell temporário antes de clonar:
> ```bash
> nix-shell -p git
> ```

> [!WARNING]
> **Sobre o `/etc/nixos` existente**: o NixOS cria esse diretório por padrão com `configuration.nix` e `hardware-configuration.nix`. O script `hamra-init.sh` gerencia a transição automaticamente:
> 1. Faz backup de `/etc/nixos` para `/etc/nixos.bak`
> 2. Extrai hostname, teclado, locale e partições dos arquivos de backup
> 3. Reconstrói a estrutura com suas configurações importadas
>
> Suas configurações de hardware não serão perdidas.

```bash
# 1. Clone o repositório
git clone https://github.com/devGabrielNathan/conf ~/hamra
cd ~/hamra

# 2. Execute o wizard de inicialização
sudo bash scripts/hamra-init.sh

# 3. Entre no diretório definitivo
cd /etc/nixos

# 4. Aplique a configuração
sudo nixos-rebuild switch --flake .#main

# 5. Reinicie
sudo reboot
```

---

## Trocando de sessão

Todas as sessões são `false` por padrão. Basta ativar apenas a desejada.

### Forma 1 (recomendada) — `hosts/main/overrides.nix`

```nix
{ config, pkgs, lib, ... }: {
  hamra = {
    sessions.gnome    = true;       # ativa gnome
    defaultSession    = "gnome";    # sessão padrão do SDDM
  };
}
```

### Forma 2 — `hosts/main/hamra.json`

```json
{ "session": "gnome" }
```

### Aplicar

```bash
sudo nixos-rebuild switch --flake .#main
```

> Recovery desabilita o display manager e o Home Manager. Use apenas quando o ambiente gráfico estiver inacessível.

---

## Configuração

### Dados da máquina — `hosts/main/hamra.json`

Gerado pelo `hamra-init.sh`, este JSON centraliza os valores da máquina. É lido pelo `hamra.nix` em tempo de avaliação:

```json
{
  "userName": "gabrielnathan",
  "hostname": "nixos",
  "timezone": "America/Sao_Paulo",
  "locale": "pt_BR.UTF-8",
  "keymap": "us",
  "gpu": "intel",
  "loader": "grub",
  "grubDevice": "/dev/sda",
  "session": "plasma"
}
```

Para regenerar: `sudo bash scripts/hamra-init.sh`

### Personalizações — `hosts/main/overrides.nix`

Local ideal para customizações. Este arquivo nunca é alterado pelo wizard:

```nix
{ config, pkgs, lib, ... }: {
  hamra = {
    userName = "gabrielnathan";
    system = {
      hostname = "workstation";
      locale   = "en_US.UTF-8";
    };
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
| Hostname, timezone, locale, teclado | `hosts/main/overrides.nix` ou `hosts/main/hamra.json` |
| Driver de GPU | `hosts/main/overrides.nix` → `hamra.gpu` |
| Sessão ativa | `hosts/main/overrides.nix` → `hamra.sessions.*` |
| Sessão padrão | `hosts/main/overrides.nix` → `hamra.defaultSession` |
| Pacotes extras ou serviços do NixOS | `hosts/main/overrides.nix` |
| Apps para todas as sessões | `modules/home/common/apps.nix` |
| SDDM / tema do login | `modules/nixos/desktop/display-manager.nix` |
| Fontes do sistema | `modules/nixos/desktop/fonts.nix` |
| Áudio | `modules/nixos/desktop/audio.nix` |

---

## Estrutura do projeto

```
hamra/
├── flake.nix                          # Entrypoint (inputs + outputs)
│
├── lib/                               # Helpers Nix
│   └── default.nix
│
├── hosts/main/                        # Configuração da máquina
│   ├── default.nix                    #   Imports e specialisations
│   ├── hamra.nix                      #   Lê hamra.json → opções hamra.*
│   ├── hamra.json                     #   Seus dados (gerado pelo wizard)
│   ├── hardware-configuration.nix     #   Gerado por nixos-generate-config
│   └── overrides.nix                  #   Suas customizações (nunca sobrescrito)
│
├── profiles/                          # Receitas de sessão
│   ├── base.nix
│   ├── recovery.nix
│   └── desktop/
│       ├── common.nix                 #   Infra base: SDDM, Wayland, audio
│       ├── hyprland-caelestia.nix
│       ├── gnome.nix
│       └── plasma.nix
│
├── modules/
│   ├── nixos/                         # Módulos de sistema
│   │   ├── options/
│   │   │   └── hamra.nix              #   API pública (todas as opções hamra.*)
│   │   ├── core/                      #   Essenciais (toda sessão)
│   │   │   ├── boot.nix
│   │   │   ├── locale.nix
│   │   │   ├── network.nix
│   │   │   ├── keyboard.nix
│   │   │   ├── users.nix
│   │   │   └── security.nix
│   │   ├── desktop/                   #   Infraestrutura gráfica
│   │   │   ├── apps.nix
│   │   │   ├── audio.nix
│   │   │   ├── display-manager.nix
│   │   │   ├── fonts.nix
│   │   │   ├── gpu.nix
│   │   │   ├── polkit.nix
│   │   │   ├── portals.nix
│   │   │   └── wayland.nix
│   │   ├── sessions/                  #   Habilita DE (lib.mkIf)
│   │   │   ├── hyprland.nix
│   │   │   ├── plasma.nix
│   │   │   └── gnome.nix
│   │   └── maintenance/
│   │       └── gc.nix
│   │
│   └── home/                          # Dotfiles do usuário
│       ├── common/                    #   Shell, git, terminal, apps
│       └── caelestia/                 #   Caelestia Shell desktop
│
└── scripts/
    ├── hamra-init.sh                  # Orquestrador do wizard
    └── lib/                           # Módulos do wizard
        ├── bootstrap.sh               #   Configura /etc/nixos
        ├── discovery.sh               #   Descobre config existente
        ├── migration.sh               #   Importa configuration.nix legado
        ├── hardware.sh                #   Detecta GPU + gera hw-config
        ├── wizard.sh                  #   Assistente interativo
        ├── generator.sh               #   Gera hamra.json
        └── git.sh                     #   Inicializa repositório
```

---

## Documentação

- [`docs/ARQUITETURA.md`](docs/ARQUITETURA.md) — Arquitetura e estrutura de módulos
- [`docs/ADRs.md`](docs/ADRs.md) — Decisões de design
- [`docs/PRD.md`](docs/PRD.md) — Documento de requisitos
- [`docs/REQUISITOS.md`](docs/REQUISITOS.md) — Requisitos funcionais e não-funcionais
- [`docs/USER_STORIES.md`](docs/USER_STORIES.md) — Histórias de usuário
- [`docs/STYLE_GUIDE.md`](docs/STYLE_GUIDE.md) — Regras de formatação
- [`docs/GUIA_IA.md`](docs/GUIA_IA.md) — Guia para desenvolvimento assistido por IA
