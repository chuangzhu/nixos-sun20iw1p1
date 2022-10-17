final: prev:

rec {
  opensbi = prev.opensbi.overrideAttrs (super: {
    patches = [
      (prev.fetchpatch {
        url = "https://github.com/smaeul/opensbi/commit/5023da429ea963f230f7361b2c15e60c7e428555.patch";
        sha256 = "sha256-+ulCgexdZRp2pfsgDqgNiWysXfOO9sD3YqZbT5bG3V8=";
      })
      (prev.fetchpatch {
        url = "https://github.com/smaeul/opensbi/commit/e6793dc36a71537023f078034fe795c64a9992a3.patch";
        sha256 = "sha256-FwVe1UMXhkPVih8FrO7+cwMobAiuOj1+H6+drBgPT+4=";
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
