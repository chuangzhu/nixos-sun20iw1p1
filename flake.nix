{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
      nixosModules = {
        sd-image-licheerv = import ./sd-image-licheerv.nix;
      };
      nixosConfigurations = {
        sdImageLicheeRVInstaller = nixpkgs.lib.nixosSystem {
          # Set system modularly (nixpkgs.hostPlatform)
          system = null;
          modules = [ ./sd-image-licheerv-installer.nix ];
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
