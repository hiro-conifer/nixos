{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    eza
    bat
    wget
    git
    mangohud
    protonplus
  ];
}
