{ self, inputs, pkgs, home-manager, ... }:

let
  user = "waseemakram";
in
{

  environment.systemPackages = with pkgs; [
    cmake
    coreutils
    curl
    delta
    fd
    iterm2
    ncdu
    pam-reattach
    python3
    sops
    stow
    vim
    zsh
  ];

  programs.zsh.enable = true;
  environment.systemPath = [ "/run/current-system/sw/bin" ];

  nix = {
    package = pkgs.nix;
    linux-builder.enable = true;
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
    ];
    optimise = {
      automatic = true;
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" user ];
    };
    gc = {
      automatic = true;
      interval = { Weekday = 1; Hour = 10; Minute = 0; }; # Monday 10 AM
      options = "--delete-older-than 7d";
    };
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
    };
    taps = [
      "caskroom/cask"
      "max-sixty/worktrunk"
      "oven-sh/bun"
      "steipete/tap"
      "shopify/shopify"
      "pakerwreah/calendr"
      "anomalyco/tap"
      "nikitabobko/tap"
      "muandane/tap"
    ];
    brews = [
      "aria2"
      "awscli"
      "ccache"
      "cloudflared"
      "folly"
      "max-sixty/worktrunk/wt"
      "mole"
      "reattach-to-user-namespace"
      "oven-sh/bun/bun"
      "pnpm"
      "python@3.13"
      "python@3.14"
      "rbenv"
      "ruby@3.1"
      "peekaboo"
      "tesseract"
      "weasyprint"
      "libmagic"
    ];
    casks = [
      "claude-code"
      # "docker"
      "font-fira-code-nerd-font"
      "google-chrome"
      "iina"
      "postman"
      "proxyman"
      "discord"
      "spotify"
      "telegram"
      "the-unarchiver"
      "whatsapp"
      "spotify"
      "stats"
    ];
    masApps = {
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
  };

  system.primaryUser = user;

  system.defaults = {
    dock = {
      autohide = true;
      tilesize = 35;
      magnification = true;
      largesize = 60;
      show-process-indicators = true;
      show-recents = false;
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      FXPreferredViewStyle = "clmv"; # Column view
      ShowPathbar = true;
      ShowStatusBar = true;
      # Search in current folder by default
      FXDefaultSearchScope = "SCcf";
    };

    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleScrollerPagingBehavior = true;
      NSTableViewDefaultSizeMode = 2;
      AppleIconAppearanceTheme = "ClearDark";
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleShowAllFiles = true;

      # Keyboard repeat settings (essential for Vim)
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15; # normal minimum is 15 (225 ms)
      KeyRepeat = 2; # normal minimum is 2 (30 ms)

    };
    screencapture.location = "~/Downloads";
  };

  # Enable TouchID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };


  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
