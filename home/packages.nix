{ pkgs, ... }:

{
  home.packages = with pkgs; [
    yazi
    cava
    cmus
    autotiling
    mpv
    lutris
    grim
    slurp
    wl-clipboard
    picard
    brightnessctl
    wireplumber
    (prismlauncher.override {
      jdks = [ pkgs.jdk21 pkgs.jdk17 pkgs.jdk8 ];
      gamemodeSupport = true;
      controllerSupport = true;
    })
  ];
}
