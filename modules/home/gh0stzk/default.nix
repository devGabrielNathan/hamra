{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.hamra;
  gh0stzk = inputs.gh0stzk-dotfiles;

  # Wrapper derivation que corrige PATH e shebangs dos scripts do gh0stzk
  gh0stzk-scripts = pkgs.stdenv.mkDerivation {
    name = "gh0stzk-bin-scripts";
    src = "${gh0stzk}/config/bspwm/bin";
    phases = [ "installPhase" "fixupPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      cp -r $src/* $out/bin/
      chmod -R +x $out/bin/
    '';
    fixupPhase = ''
      patchShebangs $out/bin
      for f in $out/bin/*; do
        wrapProgram "$f" --prefix PATH : ${pkgs.lib.makeBinPath (with pkgs; [
          coreutils gnugrep gnused gawk findutils util-linux
          bash xrandr xdpyinfo bspwm sxhkd
          polybar rofi dunst picom alacritty kitty
          xdotool xdo xprop xrdb imagemagick feh jq
          playerctl pamixer pulseaudio pavucontrol
          networkmanagerapplet bluez-tools blueman
          libnotify brightnessctl procps mpd ncmpcpp
          yazi neovim jgmenu clipcat xsettingsd eww
        ])};
      done
    '';
  };

in
lib.mkIf cfg.sessions.bspwm {

  # ──────────────────────────────────────────────
  # PACOTES
  # ──────────────────────────────────────────────
  home.packages = with pkgs; [
    # WM e compositor
    bspwm sxhkd xdotool xdo xprop xrdb xss-lock

    # Compositor X11
    picom

    # Bar e widgets
    polybar eww jgmenu

    # Launcher e notificacoes
    rofi dunst clipcat xsettingsd

    # Terminal
    alacritty kitty

    # Wallpaper e visual
    feh imagemagick

    # Audio
    pamixer pulseaudio pavucontrol playerctl

    # Rede e bluetooth
    networkmanagerapplet bluez-tools blueman

    # Ferramentas
    lxappearance arandr brightnessctl libnotify papirus-icon-theme
    mpd ncmpcpp yazi jq wmctrl xdg-utils
    lxqt.lxqt-policykit

    # Scripts wrappeado com PATH correto
    gh0stzk-scripts
  ];

  # ──────────────────────────────────────────────
  # CONFIGURACOES RAW do gh0stzk (deploy via xdg.configFile)
  # ──────────────────────────────────────────────
  xdg.configFile = {
    # BSPWM core
    "bspwm/.rice"                   = { source = "${gh0stzk}/config/bspwm/.rice"; };
    "bspwm/bspwmrc"                 = { source = "${gh0stzk}/config/bspwm/bspwmrc"; };
    "bspwm/bin"                     = { source = "${gh0stzk}/config/bspwm/bin"; recursive = true; };
    "bspwm/config/sxhkdrc"          = { source = "${gh0stzk}/config/bspwm/config/sxhkdrc"; };
    "bspwm/config/system.ini"       = { source = "${gh0stzk}/config/bspwm/config/system.ini"; };
    "bspwm/config/picom.conf"       = { source = "${gh0stzk}/config/bspwm/config/picom.conf"; };
    "bspwm/config/modules"          = { source = "${gh0stzk}/config/bspwm/config/modules"; recursive = true; };
    "bspwm/config/assets"           = { source = "${gh0stzk}/config/bspwm/config/assets"; recursive = true; };
    "bspwm/config/rofi-themes"      = { source = "${gh0stzk}/config/bspwm/config/rofi-themes"; recursive = true; };
    "bspwm/config/jgmenurc"         = { source = "${gh0stzk}/config/bspwm/config/jgmenurc"; };
    "bspwm/config/jgmenu.txt"       = { source = "${gh0stzk}/config/bspwm/config/jgmenu.txt"; };
    "bspwm/config/xsettingsd"       = { source = "${gh0stzk}/config/bspwm/config/xsettingsd"; };
    "bspwm/config/.term"            = { source = "${gh0stzk}/config/bspwm/config/.term"; };
    "bspwm/config/.launcher"        = { source = "${gh0stzk}/config/bspwm/config/.launcher"; };
    "bspwm/config/NetManagerDM.ini" = { source = "${gh0stzk}/config/bspwm/config/NetManagerDM.ini"; };
    "bspwm/config/FirstMessage.txt" = { source = "${gh0stzk}/config/bspwm/config/FirstMessage.txt"; };

    # Temas (18 themes)
    "bspwm/rices"                   = { source = "${gh0stzk}/config/bspwm/rices"; recursive = true; };

    # Eww widgets
    "bspwm/eww"                     = { source = "${gh0stzk}/config/bspwm/eww"; recursive = true; };

    # Outros apps
    "alacritty"                     = { source = "${gh0stzk}/config/alacritty"; recursive = true; };
    "kitty"                         = { source = "${gh0stzk}/config/kitty"; recursive = true; };
    "gtk-3.0"                       = { source = "${gh0stzk}/config/gtk-3.0"; recursive = true; };
    "mpd"                           = { source = "${gh0stzk}/config/mpd"; recursive = true; };
    "ncmpcpp"                       = { source = "${gh0stzk}/config/ncmpcpp"; recursive = true; };
    "yazi"                          = { source = "${gh0stzk}/config/yazi"; recursive = true; };
    "nvim"                          = { source = "${gh0stzk}/config/nvim"; recursive = true; };
    "zsh"                           = { source = "${gh0stzk}/config/zsh"; recursive = true; };
  };

  home.file = {
    ".zshrc"                        = { source = "${gh0stzk}/home/.zshrc"; };
    ".gtkrc-2.0"                    = { source = "${gh0stzk}/home/.gtkrc-2.0"; };
  };

  # ──────────────────────────────────────────────
  # ZSH
  # ──────────────────────────────────────────────
  # NOTA: programs.zsh não é usado porque o .zshrc
  # raw do gh0stzk (home.file) gerencia tudo.
  # O shell padrão é definido no NixOS session module.
  # ──────────────────────────────────────────────
  # DUNST (notificacoes)
  # ──────────────────────────────────────────────
  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = 280;
        origin = "top-right";
        offset = "20x60";
        notification_limit = 20;
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        frame_width = 0;
        frame_color = "#222330";
        separator_color = "frame";
        font = "JetBrainsMono NF Medium 9";
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        icon_position = "left";
        max_icon_size = 64;
        corner_radius = 6;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close";
      };
      urgency_low = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        timeout = 10;
        highlight = "#7aa2f7";
      };
      urgency_normal = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        timeout = 10;
        highlight = "#7aa2f7";
      };
      urgency_critical = {
        background = "#1a1b26";
        foreground = "#c0caf5";
        timeout = 0;
        highlight = "#f7768e";
      };
    };
  };

  # ──────────────────────────────────────────────
  # MPD (musica)
  # ──────────────────────────────────────────────
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
  };

  # ──────────────────────────────────────────────
  # POLKIT (autenticacao grafica)
  # ──────────────────────────────────────────────
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "PolicyKit Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
