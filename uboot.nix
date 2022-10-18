{ lib
, fetchFromGitHub
, buildUBoot
, opensbi
, writeText
, dtb ? "arch/riscv/dts/sun20i-d1-lichee-rv-dock.dtb"
}:

let
  toc1Config = writeText "toc1.cfg" ''
    [opensbi]
    file = ${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
    addr = 0x40000000
    [dtb]
    file = ${dtb}
    addr = 0x44000000
    [u-boot]
    file = u-boot-nodtb.bin
    addr = 0x4a000000
  '';
in

buildUBoot {
  version = "unstable-2022-05-27";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "u-boot";
    # Last git revision from the `d1-wip` branch:
    rev = "afc07cec423f17ebb4448a19435292ddacf19c9b";
    sha256 = "sha256-ozwTTiS6PvYbv40w2xRX3fe7Pt4ZOjkVfX9pwt1JNGE=";
  };

  defconfig = "lichee_rv_defconfig";
  OPENSBI = "${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin";
  extraMeta.platforms = [ "riscv64-linux" ];

  filesToInstall = [ "u-boot.toc1" ];
  postBuild = ''
    ./tools/mkimage -T sunxi_toc1 -d ${toc1Config} u-boot.toc1
  '';
}
