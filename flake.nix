{
  description = "Nixos config flake";

  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://lean4.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

  };

  inputs.nixvim = {
    #url = "github:nix-community/nixvim";
    # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
    url = "github:nix-community/nixvim/nixos-25.11";

    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixvim,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = false;
      };
      unstable-cuda = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in
    {
      # use "nixos", or your hostname as the name of the configuration
      # it's a better practice than "default" shown in the video
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs unstable; };
        modules = [
          (
            { ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = unstable;
                  bambu-studio-cuda = unstable.bambu-studio.overrideAttrs (old: {
                    cmakeFlags = (old.cmakeFlags or [ ]) ++ [ "-DWITH_CUDA=ON" ];
                    buildInputs = (old.buildInputs or [ ]) ++ [
                      unstable.cudaPackages.cudatoolkit
                      unstable.cudaPackages.cudnn
                    ];
                  });
                })
                (final: prev: {
                  llama-cpp = unstable-cuda.llama-cpp.override {
                    cudaSupport = true;
                  };
                })
              ];

            }
          )

          nixvim.nixosModules.nixvim
          ./configuration.nix
          ./nvidia.nix
          ./unfree.nix
          ./nvim.nix
          # inputs.home-manager.nixosModules.default
        ];
      };
    };
}
