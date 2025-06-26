{
  config,
  pkgs,
  lib,
  nixpkgs,
  ...
}:
{

  # Allow unfree 

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "nvidia-x11"
	     "nvidia-settings"

             "libcublas"
	     "cuda_cccl"
	     "cuda_nvcc"
	     "cuda_cudart"
	     "cuda-merged"
	     "cuda_cuobjdump"
	     "cuda_gdb"
	     "cuda_nvdisasm"
	     "cuda_nvprune"
             "cuda_cupti"
	     "cuda_cuxxfilt"
	     "cuda_nvml_dev"
	     "cuda_nvrtc"
	     "cuda_nvtx"
	     "cuda_profiler_api"
	     "cuda_sanitizer_api"
	     "libcufft"
	     "libcurand"
	     "libcusolver"
	     "libnvjitlink"
	     "libcusparse"
	     "libnpp"

	     "ookla-speedtest"

             "vscode"

	     "mprime"

	     "trezor-suite"

	     "steam"
	     "steam-unwrapped"

	     "google-chrome"

           ];
 
}
