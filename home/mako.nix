{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;

    settings = {
      # Global
      sort = "+time";

      # Style
      font = "IosevkaTerm Nerd Font Mono 10";
      background-color = "#00000055";
      border-size = 0;
      progress-color = "source #AA000055";
      icons = 0;
      default-timeout = 0;
      ignore-timeout = 1;
      layer = "overlay";
      anchor = "top-left";
    };
  };
}
