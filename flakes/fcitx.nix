{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
      waylandFrontend = true;

      settings = {
        inputMethod = {
          GroupOrder = {
            "0" = "Default";
          };
          "Groups/0" = {
            "Name" = "Default";
            "Default Layout" = "jp";
            "Default IM" = "mozc";
          };
          "Groups/0/Items/0" = {
            "Name" = "keyboard-jp";
          };
          "Groups/0/Items/1" = {
            "Name" = "mozc";
          };
        };

        addons.classicui.globalSection = {
          PreferTextIcon = "True";
        };
      };
    };
  };
}
