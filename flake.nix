{
  inputs = {
    nixpkgs.url = "github:zhaofengli/nixpkgs/riscv";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs {
        system = "riscv64-linux";
        overlays = [ self.overlay ];
      };
    in
    {
      overlay = import ./overlay.nix;
      legacyPackages.riscv64-linux = pkgs;
      nixosConfigurations = {
        sdImageLicheeRV = nixpkgs.lib.nixosSystem {
          system = "riscv64-linux";
          modules = [ ./sd-image-licheerv.nix ];
        };
      };

      devShell.riscv64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [
          gcc
          binutils
          dtc
          swig
          (python3.withPackages (p: [ p.libfdt p.setuptools ]))
          pkg-config
          ncurses
          nettools
          bc
          bison
          flex
          perl
          rsync
          gmp
          libmpc
          mpfr
          openssl
          libelf
          cpio
          elfutils
          zstd
          gawk
          zlib
          pahole
        ];
      };
    };
}
