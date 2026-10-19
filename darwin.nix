{
  self,
  inputs,
  pkgs,
  ...
}:

let
  user = "waseemakram";
  azureFunctionsCoreTools = pkgs.azure-functions-core-tools.override {
    buildDotnetModule =
      args:
      pkgs.buildDotnetModule (
        args
        // {
          dotnet-runtime = pkgs.dotnetCorePackages.aspnetcore_8_0;
        }
      );
  };
in
{

  nixpkgs.config.allowUnfreePredicate = pkg: pkgs.lib.getName pkg == "antigravity-cli";

  # Fonts are symlinked into /Library/Fonts/Nix Fonts automatically
  environment.systemPackages = with pkgs; [
    azure-cli
    azureFunctionsCoreTools
    cmake
    coreutils
    curl
    iterm2
    lilex
    ollama
    pam-reattach
    python3
    sops
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
    registry.nixpkgs.flake = inputs.nixpkgs;
    optimise = {
      automatic = true;
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        user
      ];
    };
    gc = {
      automatic = true;
      interval = {
        Hour = 3;
        Minute = 15;
      }; # Daily at 3 AM
      options = "--delete-older-than 30d";
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
      "max-sixty/worktrunk"
      "shopify/shopify"
      "pakerwreah/calendr"
      "muandane/tap"
    ];
    brews = [
      "max-sixty/worktrunk/wt"
      "mole"
      "weasyprint"
      "libmagic"
      "helm" # not available for darwin in nix pkgs yet
      "kubelogin"
      "llama.cpp"
    ];
    casks = [
      "claude-code"
      "discord"
      "font-fira-code-nerd-font"
      "ghostty"
      "google-chrome"
      "iina"
      "meetingbar"
      "obsidian"
      "postman"
      "proxyman"
      "raycast"
      "spotify"
      "stats"
      "telegram"
      "the-unarchiver"
      "vorssaint"
      "whatsapp"
    ];
    masApps = {
      # "Numbers" = 409203825;
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

  system = {
    primaryUser = user;

    configurationRevision = self.rev or self.dirtyRev or null;
    stateVersion = 6;

    defaults = {
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
        AppleInterfaceStyleSwitchesAutomatically = false;
        AppleShowAllFiles = true;
        AppleShowAllExtensions = true;
        AppleSpacesSwitchOnActivate = false;
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
  };

  # Enable TouchID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
    watchIdAuth = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
}
