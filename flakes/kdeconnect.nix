{ pkgs, username, ... }:

{
  programs.kdeconnect.enable = true;

  home-manager.users.${username} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
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
