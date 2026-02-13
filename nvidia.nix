{
  config,
  lib,
  pkgs,
  unstable,
  ...
}:
{

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package =
      let
        base = (unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.beta;
        patch = pkgs.fetchpatch {
          url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
          sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
        };
      in
      base
      // {
        open = base.open.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [ patch ];
        });
      };
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    #package = config.boot.kernelPackages.nvidiaPackages.beta;
    #package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #  version = "580.82.09";
    #  sha256_64bit = "sha256-Puz4MtouFeDgmsNMKdLHoDgDGC+QRXh6NVysvltWlbc=";
    #  sha256_aarch64 = "sha256-YB+mQD+oEDIIDa+e8KX1/qOlQvZMNKFrI5z3CoVKUjs=";
    #  openSha256 = "sha256-YB+mQD+oEDIIDa+e8KX1/qOlQvZMNKFrI5z3CoVKUjs=";
    #  settingsSha256 = "sha256-um53cr2Xo90VhZM1bM2CH4q9b/1W2YOqUcvXPV6uw2s=";
    #  persistencedSha256 = lib.fakeSha256;
    #};

  };

  # Configure Nvidia Prime for iGPU
  hardware.nvidia.prime = {
    sync.enable = true;
    # integrated
    amdgpuBusId = "PCI:14:00:0";

    # dedicated
    nvidiaBusId = "PCI:1:00:0";
  };

}
