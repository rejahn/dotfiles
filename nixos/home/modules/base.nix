{ pkgs, unstable, ... }:

{
  home.packages = with pkgs; [
    wezterm
    brightnessctl
    networkmanagerapplet

    # cli
    btop
    wl-clipboard
    tree-sitter
    openssl
    just
    zoxide
    ffmpeg
    nix-tree
    television
    unstable.neovim
    unstable.codex
    unstable.opencode
    unstable.zed-editor
    unstable.helix
    yazi

    # GUIs
    vlc
    anki
    xournalpp
    element-desktop
    obsidian
    libreoffice-still
    spotify
    thunderbird

    # dev stuff
    gcc
    lua
    nil
    nixd
    llvm
    rustup
    git-lfs
    clang-tools
    unstable.ruff
    unstable.ty
    lua-language-server
    bash-language-server
    taplo
  ];

  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    DEFAULT_BROWSER = "firefox";
    NIXOS_OZONE_WL = "1";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "firefox.desktop";
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "eza -lah";
      lg = "lazygit";
      gs = "git status";
      zed = "zeditor";
      vim = "nvim";
      htop = "btop";
    };

    interactiveShellInit = ''
      set -g fish_greeting
      tv init fish | source
      zoxide init fish | source
    '';
  };

  systemd.user.services.nm-applet = {
    Unit = {
      Description = "NetworkManager applet";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  # This gives OpenConnect/AnyConnect in niri the same auth/prompt path GNOME has.
  systemd.user.services.polkit-gnome-authentication-agent = {
    Unit = {
      Description = "Polkit GNOME authentication agent";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };

  home.stateVersion = "25.11";
}
