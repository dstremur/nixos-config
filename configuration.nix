# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  master,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.trusted-users = [
    "root"
    "dstrebel"
  ];

  boot.kernelParams = [
    "pci=realloc"
    "pci=assign-busses"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];

  environment.variables.LIBVA_DRIVER_NAME = "nvidia";

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Fix login bug https://discourse.nixos.org/t/multi-monitor-gdm-help/60348
  systemd.services.copyGdmMonitorsXml = {
    description = "Copy monitors.xml to GDM config";
    after = [
      "network.target"
      "systemd-user-sessions.service"
      "display-manager.service"
    ];

    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo \"Running copyGdmMonitorsXml service\" && mkdir -p /run/gdm/.config && echo \"Created /run/gdm/.config directory\" && [ \"/home/dstrebel/.config/monitors.xml\" -ef \"/run/gdm/.config/monitors.xml\" ] || cp /home/dstrebel/.config/monitors.xml /run/gdm/.config/monitors.xml && echo \"Copied monitors.xml to /run/gdm/.config/monitors.xml\" && chown gdm:gdm /run/gdm/.config/monitors.xml && echo \"Changed ownership of monitors.xml to gdm\"'";
      Type = "oneshot";
    };

    wantedBy = [ "multi-user.target" ];
  };

  programs.hyprland = {
    # Install the packages from nixpkgs
    enable = true;
    # Whether to enable XWayland
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Configure console keymap
  console.keyMap = "sg";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs.unstable; [
    hplip
    cups-filters
    cups-browsed
  ];

  services.printing.package = pkgs.unstable.cups;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
  };

  # Cuda Cache
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://aseipp-nix-cache.global.ssl.fastly.net"
    ];
    trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" ];
  };

  # Enable SSD fstrim
  services.fstrim.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  # Enable fwupd
  services.fwupd.enable = true;

  # Enable gnupg
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Enable Gamemode
  programs.gamemode.enable = true;

  # Ollama
  services.ollama = {
    enable = false;
    package = pkgs.unstable.ollama-cuda;
  };

  systemd.services.ollama.serviceConfig = {
    Environment = [ "OLLAMA_HOST=0.0.0.0:11434" ];
  };

  services.open-webui = {
    enable = true;
    package = pkgs.unstable.open-webui;
    port = 9000;
    host = "127.0.0.1";
    environment = {
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434/api";
      OLLAMA_BASE_URL = "http://127.0.0.1:11434";
    };
  };
  # Install Mullvad

  services.mullvad-vpn.enable = true;

  # Install Flatpak
  services.flatpak.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dstrebel = {
    isNormalUser = true;
    description = "Diego Strebel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
    ];
    shell = pkgs.nushell;
    packages = with pkgs; [
      unstable.onedrive
      google-chrome

    ];
  };

  # enable wayland globally for slack
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  # Add Nushell to environment
  environment.shells = with pkgs; [ nushell ];

  # Install firefox.
  programs.firefox.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    comic-mono
  ];

  # disable openblas tests
  nixpkgs.overlays = [
    (final: prev: {
      openblas = prev.openblas.overrideAttrs (_: {
        doCheck = false;
      });
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pythonFinal: pythonPrev: {
          django = pythonPrev.django.overrideAttrs (oldAttrs: {
            doCheck = false;
            doInstallCheck = false;
          });
        })
      ];
    })
    (final: prev: {
      arrow-cpp = prev.arrow-cpp.overrideAttrs (oldAttrs: {
        doCheck = false;
      });
    })
    (final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (python-final: python-prev: {
          pycurl = python-prev.pycurl.overridePythonAttrs (oldAttrs: {
            doCheck = false;
          });
        })
      ];
    })
  ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    aria2
    (bambu-studio.override {
      withNvidiaGLWorkaround = true;
    })
    bc
    unstable.bitbox
    bison
    #blender
    #bottles
    btop-cuda
    cabal-install
    unstable.carapace
    clang
    clang-tools
    cloc
    cmake
    cpufetch
    cpio
    unstable.cups
    ctags
    delta
    elfutils
    elan
    ethtool
    fastfetch
    filezilla
    flex
    gcc
    gdb
    #gdal
    gmp
    gnomeExtensions.gtile
    unstable.genefer
    gmic
    gnumake
    unstable.gh
    gimp
    unstable.gmp
    git
    ghc
    gnome-tweaks
    gparted
    gpufetch
    haskell-language-server
    unstable.hashcat
    htop
    unstable.hugo
    quartus-prime-lite
    hunspell
    inkscape
    iperf
    jetbrains.idea
    kitty
    kdePackages.kleopatra
    ltex-ls
    lean4
    libelf
    libgcc
    libreoffice-qt
    libressl
    llama-cpp
    lilypond-with-fonts
    llvmPackages_latest.llvm
    unstable.llr
    unstable.llrCUDA
    lua-language-server
    lutris
    #unstable.mailspring
    mangohud
    mars-mips
    unstable.mlucas
    unstable.mprime
    unstable.mfakto
    mullvad-vpn
    unstable.musescore
    mutt
    unstable.mfaktc
    mstflint
    nasm
    nvtopPackages.full
    unstable.nextcloud-client
    nixfmt
    nix-tree
    unstable.nushell
    kdePackages.okular
    kdePackages.kcachegrind
    ookla-speedtest
    unstable.opencode
    openconnect
    unstable.orca-slicer
    # oterm
    pandoc
    pciutils
    perf
    perl
    pinentry-gnome3
    # pdal
    poppler
    popsicle
    prismlauncher
    unstable.prmers
    unstable.prpll
    protonup-ng
    # qgis
    ripgrep
    rdma-core
    #sage
    smartmontools
    unstable.slack
    temurin-bin
    texlive.combined.scheme-full
    tex-fmt
    tree-sitter
    trezor-suite
    unstable.valgrind
    vim
    vlc
    unstable.vscode
    winetricks
    unstable.wineWow64Packages.full
    wget
    x265
    unstable.xenia-canary
    xournalpp
    libva-vdpau-driver
    libvdpau-va-gl
    libva-utils
    # yubioath-flutter
    mesa
  ];

  nix.buildMachines = [
    {
      # Will be used to call "ssh builder" to connect to the builder machine.
      # The details of the connection (user, port, url etc.)
      # are taken from your "~/.ssh/config" file.
      hostName = "dstrebel-ai?ssh-key=/home/dstrebel/.ssh/id_ed25519";
      # CPU architecture of the builder, and the operating system it runs.
      # Replace the line by the architecture of your builder, e.g.
      # - Normal Intel/AMD CPUs use "x86_64-linux"
      # - Raspberry Pi 4 and 5 use  "aarch64-linux"
      # - M1, M2, M3 ARM Macs use   "aarch64-darwin"
      # - Newer RISCV computers use "riscv64-linux"
      # See https://github.com/NixOS/nixpkgs/blob/nixos-unstable/lib/systems/flake-systems.nix
      # If your builder supports multiple architectures
      # (e.g. search for "binfmt" for emulation),
      # you can list them all, e.g. replace with
      # systems = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
      system = "x86_64-linux";
      # Nix custom ssh-variant that avoids lots of "trusted-users" settings pain
      protocol = "ssh-ng";
      # default is 1 but may keep the builder idle in between builds
      maxJobs = 40;
      # how fast is the builder compared to your local machine
      speedFactor = 1;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  # required, otherwise remote buildMachines above aren't used
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
