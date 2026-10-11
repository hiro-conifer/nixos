{ config, lib, pkgs, username, ... }:

let
  remotes = [
    # "gdrive"
  ];

  fusermount = "/run/wrappers/bin/fusermount3";
in
{
  sops = {
    defaultSopsFile = ../secret.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/var/lib/sops-nix/keys.txt";

    secrets."rclone.conf" = {
      key = "rclone_config";
      owner = username;
      mode = "0400";
    };
  };

  environment.sessionVariables.RCLONE_CONFIG = config.sops.secrets."rclone.conf".path;

  environment.systemPackages = with pkgs; [
    rclone
  ];

  programs.fuse.enable = true;

  systemd.user.services = {
    "rclone@" = {
      description = "rclone mount %i";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      path = [ "/run/wrappers" pkgs.coreutils pkgs.rclone ];

      environment.RCLONE_CONFIG = config.sops.secrets."rclone.conf".path;

      serviceConfig = {
        Type = "notify";
        ExecStartPre = [
          "${pkgs.networkmanager}/bin/nm-online -q -t 60"
          "${pkgs.coreutils}/bin/mkdir -p %h/mnt/%i"
        ];
        ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full --vfs-cache-max-size 100M %i: %h/mnt/%i";
        ExecStop = "${fusermount} -u %h/mnt/%i";
      };
    };
  }
  // lib.genAttrs (map (r: "rclone-mount@${r}") remotes) (_: {
    overrideStrategy = "asDropin";
    wantedBy = [ "default.target" ];
  });
}
