{ ... }:

{

  home-manager.users.renan =
    { pkgs, unstable, ... }:

    {

      nixpkgs.config.allowUnfree = true;

      home.packages = with pkgs; [

        firefox
        ghostty

        # cli
        btop
        wl-clipboard
        tree-sitter
        openssl
        just
        nix-tree
        television
        unstable.lazygit
        unstable.neovim
        unstable.codex
        unstable.yazi
        unstable.zed-editor
        unstable.helix

        # GUIs
        vlc
        anki
        xournalpp
        element-desktop
        obsidian
        libreoffice-still
        spotify
        thunderbird

        ## dev stuff
        nil
        nixd
        llvm
        rustup
        clang-tools
        unstable.ruff
        unstable.ty
      ];

      programs.fish = {
        enable = true;

        shellAliases = {
          ll = "eza -lah";
          lg = "lazygit";
          zed = "zeditor";
          vim = "nvim";
          htop = "btop";
        };

        shellInit = ''
          set -g fish_greeting
          tv init fish | source
          direnv hook fish | source
          zoxide init fish | source
        '';
      };

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      home.stateVersion = "25.11";
    };
}
