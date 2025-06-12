{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
	{
	  nixpkgs.overlays = [ 
	    (final: prev: {
	      unstable = import nixpkgs-unstable {
	      	inherit prev; 
		system = prev.system;
		config.allowUnfree = true; 
		};
		})
		];

}
        ./configuration.nix
        ./nvidia.nix
	# inputs.home-manager.nixosModules.default
      ];
    };
  };
}
