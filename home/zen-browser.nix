{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    policies = {
      OfferToSaveLogins = false;
      AutofillCreditCardEnabled = false;
      AutofillAddressEnabled = false;

      ExtensionSettings =  {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          installation_mode = "force_installed";
        };
      };
      "3rdparty" = {
        "Extensions" = {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            environment = {
              base = "https://vaultwarden-gce.sheep-cichlid.ts.net";
            };
          };
        };
      };
    };

    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        "extensions.autoDisableScopes" = 0;
        "signon.management.page.breach-alerts.enabled" = false;
        "intl.locale.requested" = "ja";
        "intl.accept_languages" = "ja, en-US, en";
        "browser.download.folderList" = 2;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";
        "browser.cache.disk.parent_directory" = "/tmp";
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        vimium
	      violentmonkey
      ];
    };
  };

  xdg.userDirs = {
    enable = true;
    download = "${config.home.homeDirectory}/Downloads";
  };
}
