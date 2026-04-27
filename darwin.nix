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
    enableZshIntegration = true;
    taps = [
      "caskroom/cask"
      "max-sixty/worktrunk"
      "steipete/tap"
      "shopify/shopify"
      "pakerwreah/calendr"
      "muandane/tap"
    ];
    brews = [
      "max-sixty/worktrunk/wt"
      "mole"
      "peekaboo"
      "weasyprint"
      "libmagic"
      "helm" # not available for darwin in nix pkgs yet
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
      "ghostty"
      "obsidian"
    ];
    masApps = {
      "Numbers" = 409203825;
    };
  };

  networking = {
    applicationFirewall = {
      enable = true;
      enableStealthMode = true;
    };

    #To display a list of all the network services on the server’s hardware ports, use networksetup -listallnetworkservices.
    knownNetworkServices = [
      "Thunderbolt Bridge"
      "Wi-Fi"
      "iPhone USB"
      "ProtonVPN"
    ];

    dns = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
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
      enable-spring-load-actions-on-all-items = true;
      showDesktopGestureEnabled = true;
      showLaunchpadGestureEnabled = true;
      showAppExposeGestureEnabled = true;
      showMissionControlGestureEnabled = true;
    };

    controlcenter = {
      BatteryShowPercentage = true;
      Bluetooth = false;
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
      AppleShowAllExtensions = true;
      AppleTemperatureUnit = "Celsius";

      # Keyboard repeat settings (essential for Vim)
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15; # normal minimum is 15 (225 ms)
      KeyRepeat = 2; # normal minimum is 2 (30 ms)

    };

    screencapture = {
      location = "~/Downloads";
      target = "clipboard";
      type = "png";
    };

  };

  # Enable TouchID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
    watchIdAuth = true;
  };


  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
