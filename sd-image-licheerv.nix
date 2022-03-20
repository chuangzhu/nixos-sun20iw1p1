{ config, lib, pkgs, modulesPath, ... }:

{
  nixpkgs.overlays = [ (import ./overlay.nix) ];

  imports = [
    "${modulesPath}/installer/sd-card/sd-image.nix"
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/installation-device.nix"
  ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.consoleLogLevel = lib.mkDefault 7;
  boot.kernelPackages = pkgs.linuxPackages_nezha;
  boot.kernelParams = [ "console=ttyS0,115200n8" "console=tty0" ];
  boot.initrd.availableKernelModules = lib.mkForce [ "usbhid" "usb_storage" "sd_mod" "sr_mod" ];

  # Exclude zfs
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" ];

  sdImage = {
    firmwarePartitionOffset = 20;
    postBuildCommands = ''
      dd if=${pkgs.sun20i-d1-spl}/boot0_sdcard_sun20iw1p1.bin of=$img bs=512 seek=16
      dd if=${pkgs.ubootLicheeRV}/u-boot.toc1 of=$img bs=512 seek=32800
    '';
    populateRootCommands = ''
      mkdir -p ./files/boot
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';
    # Sun20i_d1_spl doesn't support loading U-Boot from a partition. The line below is a stub
    populateFirmwareCommands = "";
  };

  installer.cloneConfig = false;
}
