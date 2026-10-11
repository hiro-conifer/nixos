{ config, pkgs, username, ... }:

let
  accountsConf = config.sops.secrets."aerc-accounts".path;

  aerc = pkgs.symlinkJoin {
    name = "aerc-wrapped";
    paths = [ pkgs.aerc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/aerc --add-flags "--accounts-conf ${accountsConf}"
    '';
  };
in
{
  sops.secrets."aerc-accounts" = {
    key = "aerc_accounts";
    owner = username;
    mode = "0400";
  };

  environment.systemPackages = [ aerc ];
}
