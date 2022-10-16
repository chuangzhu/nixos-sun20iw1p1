{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    ./sd-image-licheerv.nix
    "${modulesPath}/profiles/base.nix"
    "${modulesPath}/profiles/installation-device.nix"
  ];

  installer.cloneConfig = false;

  # For cross builds from platforms other than 'x86_64-linux', edit the following line
  # For native / emulated builds, comment out the following line
  nixpkgs.buildPlatform = "x86_64-linux";
}
