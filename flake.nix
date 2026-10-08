{
  description = "Docker VPS host configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.docker-vps = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit self inputs; };
      system = "x86_64-linux";
      modules = [
        ./modules
        
        (let
          hardwareConfig = /etc/nixos/hardware-configuration.nix;
        in
          if builtins.pathExists hardwareConfig
            then hardwareConfig
            else ./examples/hardware-configuration.nix
        )
        
        (let
          localConfig = /etc/nixos/local-configuration.nix;
        in
          if builtins.pathExists localConfig 
            then localConfig 
            else ./examples/local-configuration.nix
        )
      ];
    };
  };
}
