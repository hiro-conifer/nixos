{ lib, pkgs, ... }:

let
  vars = builtins.fromJSON (builtins.readFile ../variables.json);
  enable = (vars.gpu or "") == "amd";
in
{
  config = lib.mkIf enable {
    services.xserver.videoDrivers = [ "amdgpu" ];
    hardware.amdgpu.initrd.enable = true;
    services.lact.enable = true;
    hardware.amdgpu.overdrive.enable = true;
    hardware.amdgpu.opencl.enable = true;
    environment.systemPackages = with pkgs; [ nvtopPackages.amd vulkan-tools ];
  };
}
