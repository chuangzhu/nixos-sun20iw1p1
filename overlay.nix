final: prev:

rec {
  opensbi = prev.opensbi.overrideAttrs (super: {
    patches = [
      (prev.fetchpatch {
        name = "lib-utils-fdt-Require-match-data-to-be-const.patch";
        url = "https://github.com/smaeul/opensbi/commit/d53ad4541869f058e806133d7d5653d014b89b76.patch";
        sha256 = "sha256-EKaSbpH/Oc5gVJN2EpVnUnAt0AUinm0C9hgiaMV3ro4=";
      })
      (prev.fetchpatch {
        name = "lib-utils-timer-Add-a-separate-compatible-for-the-D1.patch";
        url = "https://github.com/smaeul/opensbi/commit/4bcaf9aa1dbc69ccb68998c7d462ef895163d493.patch";
        sha256 = "sha256-sqQtWBRREx+xs30S/kzNQG6Us0ZjYlGrmSb/LHUBaPI=";
      })
    ];
  });
  sun20i-d1-spl = prev.callPackage ./spl.nix { };
  ubootLicheeRV = prev.callPackage ./uboot.nix { };
  linux_nezha = prev.callPackage ./linux.nix { };
  linuxPackages_nezha = packagesFor linux_nezha;

  packagesFor = kernel:
    let origin = prev.linuxKernel.packagesFor kernel; in
    origin // {
      rtl8723ds = origin.callPackage ./rtl8723ds.nix { };
    };
}
