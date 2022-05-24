final: prev:

rec {
  opensbi = prev.opensbi.overrideAttrs (super: {
    patches = [ ./0001-lib-utils-fdt-Require-match-data-to-be-const.patch ./0002-lib-utils-timer-Add-a-separate-compatible-for-the-D1.patch ];
  });
  sun20i-d1-spl = prev.pkgs.callPackage ./spl.nix { };
  ubootLicheeRV = prev.pkgs.callPackage ./uboot.nix { };
  linux_nezha = prev.pkgs.callPackage ./linux.nix { };
  linuxPackages_nezha = packagesFor linux_nezha;

  packagesFor = kernel:
    let origin = prev.linuxKernel.packagesFor kernel; in
    origin // {
      rtl8723ds = origin.callPackage ./rtl8723ds.nix { };
    };
}
