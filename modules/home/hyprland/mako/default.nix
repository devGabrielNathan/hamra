{ config, ... }:

let palette = config.colorScheme.palette; in {
  services.mako = {
    enable = true;
    settings = {
      background-color = "#${palette.base00}";
      text-color = "#${palette.base05}";
      border-color = "#${palette.base04}";
      progress-color = "over #${palette.base0D}";
      border-radius = 0;
      border-size = 2;
      default-timeout = 5000;
      font = "CaskaydiaMono Nerd Font 10";
      width = 420;
      height = 110;
      padding = "10";
      margin = "10";
      max-visible = 5;
      sort = "-time";
      group-by = "app-name";
      format = "<b>%s</b>\n%b";
      layer = "overlay";
      ignore-timeout = false;
      actions = true;
      markup = true;
    };
    extraConfig = ''
      [urgency=low]
      border-color=#${palette.base09}
      [urgency=normal]
      border-color=#${palette.base0D}
      [urgency=high]
      border-color=#${palette.base08}
      default-timeout=0
    '';
  };
}
