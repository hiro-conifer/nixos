{ lib, pkgs, username, ... }:

{
  programs.kdeconnect.enable = true;
  home-manager.users.${username} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    systemd.user.services =
      let
        waitForSway = {
          Unit.After = [ "sway-session.target" ];
          Service = {
            Restart = lib.mkDefault "on-failure";
            RestartSec = lib.mkDefault 3;
            LimitCORE = 0;
          };
        };
      in
      {
        kdeconnect = waitForSway;
        kdeconnect-indicator = waitForSway;
      };

    gtk = {
      enable = true;
      iconTheme = {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      };
    };
  };
}
