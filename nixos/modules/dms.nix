{
  pkgs,
  unstable,
  unstablePath,
  dms,
  ...
}:

{
  nixpkgs.overlays = [
    (final: prev: {
      dgop = unstable.dgop;
    })
  ];

  imports = [
    (unstablePath + "/nixos/modules/programs/wayland/dms-shell.nix")
  ];
  environment.systemPackages = with pkgs; [
    openconnect
    gp-saml-gui
  ];

  programs.dms-shell = {
    enable = true;
    package = dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    quickshell.package = unstable.quickshell;
    systemd.target = "niri.service";
    enableSystemMonitoring = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config.niri = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

}
