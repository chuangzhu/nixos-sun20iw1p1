# NixOS on Allwinner D1

```shellsession
## With Nix flakes
$ nix build .#nixosConfigurations.sdImageLicheeRVInstaller.config.system.build.sdImage

## Or without Nix flakes
$ NIX_PATH='nixpkgs=channel:nixos-unstable' nix-build '<nixpkgs/nixos>' -I nixos-config=./sd-image-licheerv-installer.nix --arg system null -A config.system.build.sdImage
```

Due to performance limitations of current RISC-V machines, it may not be trivial to build this natively. This project currently *prefers* cross builds from `x86_64-linux`. It is recommended to add [hydra.nichi.co](https://hydra.nichi.co) to your [Nix binary cache](https://nixos.wiki/wiki/Binary_Cache#Using_a_binary_cache).

Prebuilt images can be found on the [GitHub releases page](https://github.com/chuangzhu/nixos-sun20iw1p1/releases).

## Status

The image boots successfully with WiFi and HDMI support. Supported boards:

- [x] Sipeed LicheeRV Dock
- [x] MangoPi MQ-Pro (compatible with LicheeRV)
- [ ] MangoPi MQ

[![asciicast](https://asciinema.org/a/484705.svg)](https://asciinema.org/a/484705)

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

## Configuration

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-sun20iw1p1.url = "github:chuangzhu/nixos-sun20iw1p1";
  };
  outputs = { self, nixpkgs, nixos-sun20iw1p1 }: {
    nixosConfugurations.myLicheeRV = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-sun20iw1p1.nixosModules.sd-image-licheerv
        ./hardware-configuration.nix
        ./configuration.nix
        ({ pkgs, config, ... }: {
          nixpkgs.buildPlatform = "x86_64-linux";
        })
      ];
    };
  };
}
```

Then you can build your customized SD card image using `nix build .#nixosConfigurations.myLicheeRV.config.system.build.sdImage`.

When you make changes, you can build the new configuration using `nix build .#nixosConfigurations.myLicheeRV.config.system.build.toplevel`, copy it to the running system using `nix copy --no-check-sigs --to ssh://root@ip.to.mylicheerv.example ./result`, then execute `/nix/store/xxxx-nixos-system-myLicheeRV-xxxx/switch-to-configuration switch` on the board.

### Without Nix flakes

```nix
# configuration.nix
{ config, pkgs, lib, ... }: {
  imports = [
    <nixos-sun20iw1p1/sd-image-licheerv.nix>
    ./hardware-configuration.nix
  ];
  nixpkgs.buildPlatform = "x86_64-linux";
}
```

```shellsession
$ NIX_PATH='nixpkgs=channel:nixos-unstable:nixos-sun20iw1p1=https://github.com/chuangzhu/nixos-sun20iw1p1/archive/master.tar.gz' nix-build '<nixpkgs/nixos>' -I nixos-config=configuration.nix --arg system null -A config.system.build.sdImage
```

## Credit

I followed [this guide](https://linux-sunxi.org/Allwinner_Nezha#Manual_build) from the linux-sunxi community.
Many thanks to @smaeul and other people's awesome work.
This is based on @NickCao and @zhaofengli's work porting numerous Nix packages to `riscv64-linux`.
