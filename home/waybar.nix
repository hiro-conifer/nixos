{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "backlight"
          "pulseaudio"
          "network"
        ];
        modules-center = [
          "sway/workspaces"
        ];
        modules-right = [
          "memory"
          "cpu"
          "temperature"
          "battery"
          "tray"
          "clock#date"
          "clock#time"
        ];

        backlight = {
          device = "intel_backlight";
          format = "{percent}% {icon}";
          format-icons = [ "" "" ]; # low/high brightness -- please double-check these two visually
          on-scroll-up = "brightnessctl set +5%";
          on-scroll-down = "brightnessctl set 5%-";
          scroll-step = "5";
        };

        battery = {
          interval = 3;
          states = {
            warning = 20;
            critical = 10;
          };
          # Connected to AC
          format = "{capacity}%+"; # Icon: bolt
          # Not connected to AC
          format-discharging = "{capacity}%- ";
          format-icons = [
            "" # Icon: battery-full
            "" # Icon: battery-three-quarters
            "" # Icon: battery-half
            "" # Icon: battery-quarter
            "" # Icon: battery-empty
          ];
          tooltip = false;
        };

        "clock#time" = {
          interval = 1;
          format = "{:%H:%M:%S}";
          # format = "{:%H:%M}";
          tooltip = false;
        };

        "clock#date" = {
          interval = 20;
          format = "{:%e %b %Y}"; # Icon: calendar-alt
          # tooltip-format = "{:%e %B %Y}";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          tooltip = false;
          format = "CPU {usage}%"; # Icon: microchip
          states = {
            warning = 70;
            critical = 90;
          };
        };

        "custom/keyboard-layout" = {
          exec = "~/layout.sh";
          # Interval set only as a fallback, as the value is updated by signal
          # interval = 5;
          format = "{}"; # Icon: keyboard
          # Signal sent by Sway key binding (~/.config/sway/key-bindings)
          signal = 1; # SIGHUP
          tooltip = false;
        };

        memory = {
          interval = 5;
          format = "MEM {}%"; # Icon: memory
          states = {
            warning = 70;
            critical = 90;
          };
        };

        network = {
          interval = 5;
          format-wifi = "{essid}/{ipaddr} ({signalStrength}%)"; # Icon: wifi
          format-ethernet = "{ifname}: {ipaddr}/{cidr}"; # Icon: ethernet
          format-disconnected = "Disconnected";
          tooltip-format = "{ifname}: {ipaddr}";
          on-click = "swaymsg exec wezterm start nmtui";
        };

        "sway/mode" = {
          format = "<span style=\"italic\">  {}</span>"; # Icon: expand-arrows-alt
          tooltip = false;
        };

        "sway/window" = {
          format = "{}";
          max-length = 120;
        };

        "sway/workspaces" = {
          all-outputs = false;
          disable-scroll = true;
          format = "{name}";
          format-icons = {
            "1:www" = "龜"; # Icon: firefox-browser -- this one is likely still wrong, please check
            "2:mail" = ""; # Icon: mail
            "3:editor" = ""; # Icon: code
            "4:terminals" = ""; # Icon: terminal
            "5:portal" = ""; # Icon: terminal
            urgent = "";
            focused = "";
            default = "";
          };
        };

        pulseaudio = {
          scroll-step = 10;
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree = ""; # best guess, please check
            headset = "";
            phone = "";
            portable = ""; # best guess, please check
            car = "";
            default = [ "" "" ];
          };
          on-click = "wezterm start pulsemixer";
        };

        temperature = {
          critical-threshold = 80;
          interval = 5;
          format = "{temperatureC}°C";
          format-icons = [
            "" # Icon: temperature-empty
            "" # Icon: temperature-quarter
            "" # Icon: temperature-half
            "" # Icon: temperature-three-quarters
            "" # Icon: temperature-full
          ];
          tooltip = true;
        };

        "custom/layout" = {
          # format = "{}";
          exec = "~/layout.sh";
        };

        "custom/alsa" = {
          exec = "amixer get Master | sed -nre 's/.*\\[off\\].*/ muted/p; s/.*\\[(.*%)\\].*/ \\1/p'";
          on-click = "amixer set Master toggle; pkill -x -RTMIN+11 waybar";
          on-scroll-up = "amixer set Master 1+; pkill -x -RTMIN+11 waybar";
          on-scroll-down = "amixer set Master 1-; pkill -x -RTMIN+11 waybar";
          signal = 11;
          interval = 10;
          tooltip = false;
        };

        tray = {
          icon-size = 21;
          # spacing = 10;
        };
      };
    };

    style = ''
      * {
        background-color: transparent;
        font-family: "IosevkaTerm Nerd Font Mono", "Iosevka SS08";
        font-size: 16px;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
      }

      #workspaces button.focused {
        box-shadow: inset 0 -1px #ffffff;
      }

      #workspaces button.urgent {
        background-color: #ff3333;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd {
        padding: 0 10px;
        color: #ffffff;
      }

      #window,
      #workspaces {
        margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      #battery.critical:not(.charging) {
        background-color: #ff3333;
        color: #ffffff;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #network.disconnected {
        background-color: #ff3333;
      }

      #pulseaudio.muted {
        background-color: #ff3333;
      }

      #wireplumber.muted {
        background-color: #ff3333;
      }
    '';
  };

  home.packages = with pkgs; [
    curl
    pavucontrol
  ];
}
