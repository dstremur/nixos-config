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
    powerManagement.enable = true;

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

    package = (unstable.linuxPackagesFor config.boot.kernelPackages.kernel).nvidiaPackages.new_feature;
    #package = config.boot.kernelPackages.nvidiaPackages.latest;
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
    #    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    #      version = "595.71.05";
    #      sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
    #      openSha256 = "sha256-Lfz71QWKM6x/jD2B22SWpUi7/og30HRlXg1kL3EWzEw=";
    #      settingsSha256 = "sha256-mXnf3jyvznfB3OfKd657rxv0rYHQb/dX/Riw/+N9EKU=";

    #	   usePersistenced = false;
    #    };

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
