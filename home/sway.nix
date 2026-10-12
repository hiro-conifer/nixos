{ config, pkgs, lib, ... }:

let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
  pgrep = "${pkgs.procps}/bin/pgrep";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  lock = "${pgrep} -x swaylock || ${swaylock} -f";
  lockIdle = "${lock} --grace 2";
  icon = name: "url(\"${./items + "/${name}.png"}\")";
  mgn = 20;
  hvr = 10;
  radius = 20;
in
{
  xdg = {
    configFile."kitty/startup.conf".text = ''
      layout tall
      launch btop
      launch
      launch cava
    '';
    desktopEntries = {
      yazi_desktop = {
        name = "Yazi Desktop";
        exec = "kitty -1 -e yazi %f";
        icon = "yazi";
        terminal = false;
        categories = [ "System" "FileManager" ];
      };
      aerc_desktop = {
        name = "Aerc Desktop";
        exec = "kitty -1 -e aerc";
        icon = "aerc";
        terminal = false;
      };
    };
  };

  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      ring-color = "bb00cc";
      key-hl-color = "880033";
      line-color = "00000000";
      inside-color = "00000088";
      separator-color = "00000000";
      fade-in = 0.2;
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      { label = "lock";     action = "swaylock -f";      text = "Lock (l)";     keybind = "l"; }
      { label = "logout";   action = "swaymsg exit";     text = "Logout (e)";   keybind = "e"; }
      { label = "suspend";  action = "systemctl suspend";  text = "Suspend (s)";  keybind = "s"; }
      { label = "reboot";   action = "systemctl reboot";   text = "Reboot (r)";   keybind = "r"; }
      { label = "shutdown"; action = "systemctl poweroff"; text = "Shutdown (p)"; keybind = "p"; }
    ];
    style = ''
      @define-color wl-bg rgba(0, 0, 0, 0.75);
      @define-color wl-button-fg #ffffff;
      @define-color wl-button-bg rgba(255, 255, 255, 0.12);
      * {
        background-image: none;
        font-size: 16px;
      }
      window {
        background-color: @wl-bg;
      }
      button {
        color: @wl-button-fg;
        font-weight: bold;
        background-color: transparent;
        outline-style: none;
        border: none;
        border-width: 0px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 20%;
        border-radius: 13px;
        box-shadow: none;
        text-shadow: none;
        margin: ${toString mgn}px;
      }
      button:focus {
        background-color: @wl-button-bg;
      }
      button:hover {
        background-color: @wl-button-bg;
        background-size: 40%;
        border-radius: ${toString radius}px;
        margin: ${toString hvr}px;
        transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682);
      }
      #lock {
        background-image: ${icon "lock"};
      }
      #logout {
        background-image: ${icon "logout"};
      }
      #suspend {
        background-image: ${icon "suspend"};
      }

      #reboot {
        background-image: ${icon "reboot"};
      }

      #shutdown {
        background-image: ${icon "shutdown"};
      }
    '';
  };

  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "default";
          outputs = [
            { criteria = "*"; status = "enable"; }
          ];
        };
      }
    ];
  };

  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 19 * 60;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
      {
        timeout = 20 * 60;
        command = lockIdle;
      }
      {
        timeout = 30 * 60;
        command = "${systemctl} suspend";
      }
    ];
    events = {
      "before-sleep" = lock;
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    xwayland = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty -1";
      
      gaps = {
        inner = 10;
      };

      window.commands = [
        {
          criteria = { shell = ".*"; };
          command = "inhibit_idle fullscreen";
        }
        {
          criteria = { class = "^[Ss]team$"; };
          command = "floating enable";
        }
        {
          criteria = { class = "^[Ss]team_app*"; };
          command = "floating enable";
        }
        {
          criteria = { class = "^[Ss]team$"; title = "^Steam$"; };
          command = "floating disable";
        }
        {
          criteria = { class = "^[Ss]team$"; title = "^Sign in to Steam$"; };
          command = "move to scratchpad";
        }
      ];
      
      assigns = {
        "1" = [
          { app_id = "startup"; }
        ];
        "2" = [
          { app_id = "zen-twilight"; }
        ];
        "3" = [
          { app_id = "kitty_aerc"; }
        ];
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+d" = "exec wofi --show drun";
        "${modifier}+e" = "exec kitty -1 --class yazi_desktop -e yazi";
        "${modifier}+q" = "kill";
        "${modifier}+z" = "exec zen-twilight";
        "${modifier}+l" = "exec swaylock";
        "${modifier}+Shift+e" = "exec wlogout -b 5";

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
	  bg = "${./items/wallpaper.png} fill";
	};
      };

      bars = [
        {
          command = "waybar";
        }
      ];
      
      startup = [
        { command = "fcitx5"; }
        { command = "blueman-applet"; }
        { command = "kdeconnect-indicator"; }
        { command = "autotiling"; }
        { command = "mako"; }
        { command = "swaymsg workspace number 1"; }
        { command = "kitty -1 --class 'startup' --session ${config.xdg.configHome}/kitty/startup.conf"; }
        { command = "zen-twilight"; }
        { command = "kitty -1 --class 'kitty_aerc' -e aerc"; }
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
