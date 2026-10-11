{ lib, ... }:

let
  vars = builtins.fromJSON (builtins.readFile ../variables.json);
  mounts = vars.mounts or [ ];
in
{
  fileSystems = lib.listToAttrs (map
    (m: {
      name = "/mnt/${m.name}";
      value = {
        device = "/dev/disk/by-uuid/${m.uuid}";
        fsType = m.fsType or "ext4";
        options = [
          "nofail"
          "x-systemd.device-timeout=5s"
        ] ++ (m.options or [ ]);
      };
    })
    mounts);
}
