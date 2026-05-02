{ pkgs, unstable, ... }:

{
  programs.lazygit = {
    enable = true;
    package = unstable.lazygit;
    settings = {
      git = {
        autoFetch = false;
      };
    };
  };
}
