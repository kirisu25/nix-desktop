{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        poetry2nix = inputs.poetry2nix.lib.mkPoetry2Nix { inherit pkgs; };
      in
      # waybar-wtr = pkgs.poetry2nix.mkPoetryApplication { projectDir = ./.; };
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            python312Full
            poetry
          ];
        };
        packages = {
          waybar-wtr = poetry2nix.mkPoetryApplication {
            profectDir = ./waybar-wtr/.;
          };
          defaut = self.packages.${system}.waybar-wtr;
        };
      }
    );
}
