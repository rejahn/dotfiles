{ pkgs, lib, ... }:

{
  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable dconf so GNOME settings can be managed
  programs.dconf.enable = true;

  # GNOME defaults
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
          ];
          favorite-apps = [
            "firefox.desktop"
            "com.mitchellh.ghostty.desktop"
            "dev.zed.Zed.desktop"
            "thunderbird.desktop"
            "org.gnome.Nautilus.desktop"
            "element-desktop.desktop"
          ];
        };

        "org/gnome/shell/keybindings" = {
          show-screenshot-ui = [ "<Super><Shift>s" ];
        };

        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "Adwaita-dark";
          show-battery-percentage = true;
          clock-format = "24h";
          clock-show-weekday = true;
        };

        "org/gnome/desktop/applications/terminal" = {
          exec = "ghostty";
          exec-arg = "";
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout = ":minimize,maximize,close";
        };

        "org/gnome/desktop/session" = {
          idle-delay = lib.gvariant.mkUint32 900;
        };

        "org/gnome/desktop/screensaver" = {
          lock-enabled = true;
          lock-delay = lib.gvariant.mkUint32 0;
        };

      };
    }
  ];

  # GNOME Shell extensions (system-wide)
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
  ];
}
