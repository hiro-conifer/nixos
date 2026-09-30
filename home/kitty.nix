{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "IosevkaTerm Nerd Font Mono";
      size = 9;
    };

    settings = {
      # -- base colors (wezterm: foreground / background) --
      foreground = "white";
      background = "black";
      # wezterm's background is "transparent"; kitty controls this via
      # opacity instead of a color. Remove the next line if you want a
      # fully opaque window.
      # background_opacity = "0.6";

      # -- cursor (wezterm: cursor_bg / cursor_fg) --
      cursor = "darkred";
      cursor_text_color = "lightpink";

      # -- selection (wezterm: selection_bg / selection_fg) --
      selection_background = "lightgrey";
      selection_foreground = "black";

      # -- ansi 0-7 --
      color0 = "black";
      color1 = "#9f0000";
      color2 = "#cc0066";
      color3 = "#cc6600";
      color4 = "#af5f5f";
      color5 = "#af0000";
      color6 = "#aa4538";
      color7 = "#606060";

      # -- brights 8-15 --
      color8 = "#c2c2c2";
      color9 = "#ff4d4d";
      color10 = "#ff99cc";
      color11 = "#ffbf80";
      color12 = "#d78787";
      color13 = "#d75f5f";
      color14 = "#ff875f";
      color15 = "white";
    };
  };
}
