{
  description = "Kovaxs Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
        # pkgs.vlc-bin
        pkgs.adwaita-icon-theme
        pkgs.ansible
        pkgs.ansible-lint
        pkgs.at-spi2-core
        pkgs.bat
        pkgs.btop
        pkgs.ctop
        pkgs.darwin.iproute2mac
        pkgs.dbus
        pkgs.fd
        pkgs.ffmpeg
        pkgs.ffmpegthumbnailer
        pkgs.fontforge
        pkgs.fzf
        pkgs.ghostscript
        pkgs.girara
        pkgs.git
        pkgs.git-lfs
        pkgs.glow
        pkgs.graphviz
        pkgs.gtk3
        pkgs.htop
        pkgs.imagemagick
        pkgs.irssi
        pkgs.jq
        pkgs.k9s
        pkgs.kind
        pkgs.lazygit
        pkgs.librsvg
        pkgs.ncdu
        pkgs.neovim
        pkgs.pkg-config
        pkgs.texliveFull
        pkgs.yazi
        pkgs.zathura
        pkgs.luarocks
        pkgs.nmap
        pkgs.poppler
        pkgs.portaudio
        pkgs.pstree
        pkgs.ripgrep
        pkgs.sphinx
        pkgs.tmux
        pkgs.tree
        pkgs.watch
        pkgs.wget
        pkgs.xclip
        pkgs.zoxide

        # pkgs.kitty
        # pkgs.node
        # pkgs.py3cairo
        # pkgs.pygobject3
        # pkgs.sevenzip
        # pkgs.font-symbols-only-nerd-font
        # pkgs.xdotool
        # pkgs.qmk-toolbox
        # pkgs.podman-desktop
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;
      # programs.bash.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."kovaxs" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."kovaxs".pkgs;
  };
}
