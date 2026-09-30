{ config, pkgs, lib, ... }:

{
  xdg.configFile."kitty/startup.conf".text = ''
    layout tall
    launch btop
    launch
    launch cava
  '';

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty -1";
      
      gaps = {
        inner = 10;
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec wofi --show drun";
        "${modifier}+q" = "kill";
        "${modifier}+z" = "exec zen-twilight";

        "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
        "XF86MonBrightnessUp" = "exec brightnessctl set 5%+";
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        "XF86AudioMicMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

        "Print" = "exec mkdir -p ~/Pictures && grim ~/Pictures/$(date +%Y%m%d%H%M%S).png";
        "Shift+Print" = "exec mkdir -p ~/Pictures && grim -g \"$(slurp)\" ~/Pictures/$(date +%Y%m%d%H%M%S).png";
      };

      input = {
        "*" = {
          xkb_options = "ctrl:nocaps";
          xkb_layout = "jp";
        };
      };

      output = {
        "*" = {
	  bg = "${./wallpaper.png} fill";
	};
      };

      bars = [
        {
          command = "waybar";
        }
      ];
      
      startup = [
        { command = "fcitx5"; }
        { command = "autotiling"; }
        { command = "mako"; }
        { command = "kitty --session ${config.xdg.configHome}/kitty/startup.conf"; }
      ];
    };

    extraConfig = ''
      default_border none
      default_floating_border none
      titlebar_padding 1
      titlebar_border_thickness 0

      for_window [class=".*"] opacity 0.75
      for_window [app_id=".*"] opacity 0.75
      for_window [floating] opacity 1
      for_window [app_id="wofi"] opacity 0.75
    '';
  };
}
