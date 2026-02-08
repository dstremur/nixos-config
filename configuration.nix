# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
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
    "pcie_aspm=off"
    "iommu=pt"
    "amd_iommu=on"
    "pci=noaer"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Enable Wayland
  services.displayManager.gdm.wayland = true;

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

  # Cuda Cache
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "https://cache.nixos-cuda.org" ];
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
    enable = true;
    package = pkgs.unstable.ollama-cuda;
    acceleration = "cuda";
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

  # Add Nushell to environment
  environment.shells = with pkgs; [ nushell ];

  # Install firefox.
  programs.firefox.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    fira-code
    comic-mono
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    aria2
    unstable.bambu-studio
    unstable.bitbox
    blender
    bottles
    btop-cuda
    cabal-install
    unstable.carapace
    cmake
    cpufetch
    unstable.cups
    elan
    ethtool
    fastfetch
    filezilla
    gcc
    gdal
    gmic
    unstable.gh
    gimp
    git
    ghc
    gnome-tweaks
    gparted
    haskell-language-server
    unstable.hashcat
    htop
    unstable.hugo
    hunspell
    inkscape
    iperf
    jetbrains.idea-oss
    kitty
    kdePackages.kleopatra
    ltex-ls
    lean4
    libgcc
    libreoffice-qt
    librechat
    llama-cpp
    lilypond-with-fonts
    lua-language-server
    unstable.lutris
    unstable.mailspring
    mangohud
    mprime
    mullvad-vpn
    musescore
    unstable.mfaktc
    mstflint
    nasm
    neofetch
    unstable.nextcloud-client
    nixfmt-rfc-style
    nix-tree
    unstable.nushell
    kdePackages.okular
    ookla-speedtest
    openconnect
    unstable.orca-slicer
    oterm
    pandoc
    pciutils
    pinentry-gnome3
    pdal
    poppler
    popsicle
    prismlauncher
    unstable.prmers
    protonup-ng
    qgis
    ripgrep
    rdma-core
    sage
    smartmontools
    temurin-bin
    texlive.combined.scheme-full
    tex-fmt
    thonny
    tree-sitter
    trezor-suite
    vim
    vlc
    vscode
    winetricks
    wineWowPackages.full
    wget
    x265
    unstable.xenia-canary
    xournalpp
    libva-vdpau-driver
    libvdpau-va-gl
    libva-utils
    mesa
  ];

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
