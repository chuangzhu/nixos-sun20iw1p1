{
  inputs = {
    nixpkgs.url = "github:zhaofengli/nixpkgs/riscv";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      pkgs = import nixpkgs {
        system = "riscv64-linux";
        overlays = [ self.overlay ];
      };
    in
    {
      overlay = import ./overlay.nix;
      legacyPackages.riscv64-linux = pkgs;
      devShell.riscv64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [
          gcc
          binutils
          bison
          flex
          dtc
          openssl
          bc
          swig
          (python3.withPackages (p: [ p.libfdt p.setuptools ]))
        ];
      };
    };
}
