{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.05 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    
    home-manager = {
    url = "github:nix-community/home-manager/release-25.05"; # Use the branch matching your nixpkgs (24.05) or the latest
    inputs.nixpkgs.follows = "nixpkgs";
  };
  
 };
  
  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        
        {
          # Configure Home Manager for your user
          home-manager.users.ryuuma = import ./home.nix; 
          home-manager.useUserPackages = true;
          home-manager.useGlobalPkgs = true;
          home-manager.backupFileExtension = "backup";

          
        }
      ];
    };
  };
}
