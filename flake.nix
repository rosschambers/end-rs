{
  description = "Eww notification daemon (in Rust)";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = nixpkgs.legacyPackages;
    in {
      packages = forAllSystems (system: {
        default = pkgsFor.${system}.callPackage ./. { };
      });
      
      devShells = forAllSystems (system: 
        let 
          pkgs = pkgsFor.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              rustc
              cargo
              rustfmt
              rust-analyzer
              clippy
              libiconv
              pkg-config
            ];
            
            # Environment variables
            RUSTC_BOOTSTRAP = 1;
          };
        }
      );
    };
}

