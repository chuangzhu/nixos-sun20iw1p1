# NixOS on Allwinner D1

```shellsession
## With Nix flakes
$ nix build .#nixosConfigurations.sdImageLicheeRV.config.system.build.sdImage

## Or without Nix flakes
$ git clone https://github.com/zhaofengli/nixpkgs.git -b riscv ../nixpkgs
$ nix-build ../nixpkgs/nixos -I nixos-config=./sd-image-licheerv.nix -I nixpkgs=../nixpkgs --argstr system riscv64-linux -A config.system.build.sdImage
```

For cross compiling, add this to your `configuration.nix`:

```nix
  boot.binfmt.emulatedSystems = [ "riscv64-linux" ];
```

Precompiled images can be found on the [GitHub releases page](https://github.com/chuangzhu/nixos-sun20iw1p1/releases).

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
