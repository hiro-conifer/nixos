{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.twilight
  ];

  programs.zen-browser = {
    enable = true;
    # Same shape as Firefox's policies.json.
    policies = {
      "3rdparty" = {
        "Extensions" = {
          # Bitwarden Password Manager's Firefox extension ID.
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

      # Extensions installed outside the store's install flow (like these,
      # placed directly via Nix) are auto-disabled by default. This tells
      # Firefox/Zen not to do that for any installation scope, so they come
      # up enabled from the start.
      settings = {
        "extensions.autoDisableScopes" = 0;

        # Browser Language (UI language).
        "intl.locale.requested" = "ja";

        # Website Languages, in priority order (Accept-Language header).
        "intl.accept_languages" = "ja, en-US, en";

        # Force the download folder to an explicit English path, rather
        # than following XDG_DOWNLOAD_DIR (which can end up localized,
        # e.g. ~/ダウンロード).
        "browser.download.folderList" = 2;
        "browser.download.dir" = "${config.home.homeDirectory}/Downloads";

        # Store the disk cache under /tmp instead of the profile directory.
        "browser.cache.disk.parent_directory" = "/tmp";
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        vimium
	violentmonkey
      ];
    };
  };

  # AdGuard Extra (one-time manual step, after rebuild + restarting Zen):
  #   Open the URL below in Zen and confirm the Greasemonkey install prompt.
  #   https://userscripts.adtidy.org/release/adguard-extra/1.0/adguard-extra.user.js
  # The script updates itself via its @updateURL, so no hash needs updating here.
}
