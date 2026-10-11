{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;

    font = {
      name = "IosevkaTerm Nerd Font Mono";
      size = 9;
    };

    settings = {
      foreground = "white";
      background = "black";
      cursor = "darkred";
      cursor_text_color = "lightpink";
      selection_background = "lightgrey";
      selection_foreground = "black";

      color0 = "black";
      color1 = "#9f0000";
      color2 = "#cc0066";
      color3 = "#cc6600";
      color4 = "#af5f5f";
      color5 = "#af0000";
      color6 = "#aa4538";
      color7 = "#606060";
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
