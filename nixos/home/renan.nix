{ ... }:

{
  home-manager.users.renan = {
    imports = [
      ./modules/base.nix
      ./modules/rofi.nix
      # ./modules/walker.nix
      ./modules/niri.nix
      ./modules/lazygit.nix
    ];
  };
}
