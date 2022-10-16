# NixOS on Allwinner D1

```shellsession
## With Nix flakes
$ nix build .#nixosConfigurations.sdImageLicheeRVInstaller.config.system.build.sdImage

## Or without Nix flakes
$ NIX_PATH='nixpkgs=channel:nixos-unstable' nix-build '<nixpkgs/nixos>' -I nixos-config=./sd-image-licheerv-installer.nix --arg system null -A config.system.build.sdImage
```

Due to performance limitations of current RISC-V machines, it may not be trivial to build this natively. This project currently *prefers* cross builds from `x86_64-linux`. It is recommended to add [hydra.nichi.co](https://hydra.nichi.co) to your Nix substituters:

```nix
# On NixOS, edit /etc/nixos/configurations.nix
nix.settings = {
  substituters = [ "https://cache.nichi.co" ];
  trusted-public-keys = [ "hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk=" ];
};
```

```ini
# On non-NixOS, edit /etc/nix/nix.conf
substituters = https://cache.nichi.co https://cache.nixos.org/
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk=
```

Prebuilt images can be found on the [GitHub releases page](https://github.com/chuangzhu/nixos-sun20iw1p1/releases).

## Other build options

For cross builds from other platforms, edit `sd-image-licheerv-installer.nix`:

```diff
-  nixpkgs.buildPlatform = "x86_64-linux";
+  nixpkgs.buildPlatform = "aarch64-linux";
```

For native / emulated builds, edit `sd-image-licheerv-installer.nix`:

```diff
-  nixpkgs.buildPlatform = "x86_64-linux";
```

For emulated builds on NixOS, add this to your system's `configuration.nix`:

```nix
  boot.binfmt.emulatedSystems = [ "riscv64-linux" ];
```

For emulated builds on non-NixOS, check [this discourse](https://discourse.nixos.org/t/how-to-configure-qemu-binfmt-wrapper-on-a-non-nixos-machine/7879/6).

## Status

The image boots successfully with WiFi support. HDMI driver is currently missing. Supported boards:

- [x] Sipeed LicheeRV Dock
- [x] MangoPi MQ-Pro (compatible with LicheeRV)
- [ ] MangoPi MQ

[![asciicast](https://asciinema.org/a/484705.svg)](https://asciinema.org/a/484705)

## Credit

I followed [this guide](https://linux-sunxi.org/Allwinner_Nezha#Manual_build) from the linux-sunxi community.
Many thanks to @smaeul and other people's awesome work.
This is based on @zhaofengli's work porting numerous Nix packages to `riscv64-linux`.
