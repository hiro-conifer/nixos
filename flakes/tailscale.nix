{ config, username, ... }:

{
  sops.secrets."tailscale-authkey" = {
    key = "tailscale_authkey";
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.sops.secrets."tailscale-authkey".path;

    extraSetFlags = [
      "--ssh"
      "--accept-routes"
      "--operator=${username}"
    ];
  };
}
