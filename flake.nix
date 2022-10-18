{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    overlays.default = import ./overlay.nix;
    legacyPackages = {
      riscv64-linux = import nixpkgs {
        system = "riscv64-linux";
        overlays = [ self.overlays.default ];
      };
      # legacyPackages.x86_64-linux.pkgsCross.riscv64
      x86_64-linux = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ self.overlays.default ];
      };
    };
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

    devShells.x86_64-linux.default = with self.legacyPackages.x86_64-linux.pkgsCross.riscv64; mkShell {
      buildInputs = [
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
      shellHook = ''
        export ARCH=${stdenv.hostPlatform.linuxArch}
        export CROSS_COMPILE=${stdenv.cc.targetPrefix}
      '';
    };
  };
}
