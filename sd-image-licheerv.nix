{ config, lib, pkgs ? import <nixpkgs>, modulesPath, ... }:

{
  nixpkgs.overlays = [ (import ./overlay.nix) ];

  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/installation-device.nix"
  ];

  boot = {
    loader.grub.enable = false;
    loader.generic-extlinux-compatible.enable = true;

    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = pkgs.linuxPackages_nezha;
    kernelParams = [ "console=ttyS0,115200n8" "console=tty0" "earlycon=sbi" ];

    initrd.availableKernelModules = lib.mkForce [ ];

    extraModulePackages = [ pkgs.linuxPackages_nezha.rtl8723ds ];
    # Exclude zfs
    supportedFilesystems = lib.mkForce [ ];
  };

  sdImage = {
    firmwarePartitionOffset = 20;
    postBuildCommands = ''
      dd conv=notrunc if=${pkgs.sun20i-d1-spl}/boot0_sdcard_sun20iw1p1.bin of=$img bs=512 seek=16
      dd conv=notrunc if=${pkgs.ubootLicheeRV}/u-boot.toc1 of=$img bs=512 seek=32800
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    # Sun20i_d1_spl doesn't support loading U-Boot from a partition. The line below is a stub
    populateFirmwareCommands = "";
    # compressImage = false;
  };

  nix.settings = {
    substituters = [ "https://unmatched.cachix.org" ];
    trusted-public-keys = [ "unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc=" ];
    experimental-features = "nix-command flakes";
    # TODO: figure out what config is needed to use sandbox
    sandbox = false;
  };

  installer.cloneConfig = false;
}
