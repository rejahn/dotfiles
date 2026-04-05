{ pkgs, ... }:

{
  home.username = "renan";
  home.homeDirectory = "/home/renan";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
