{ pkgs, ... }:

{
  home.packages = with pkgs; [
    playerctl
  ];

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;
}
