{ lib
, fetchFromGitHub
, buildUBoot
, opensbi
, writeText
}:

let
  toc1Config = writeText "toc1.cfg" ''
    [opensbi]
    file = ${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin
    addr = 0x40000000
    [dtb]
    file = arch/riscv/dts/sun20i-d1-lichee-rv-dock.dtb
    addr = 0x44000000
    [u-boot]
    file = u-boot-nodtb.bin
    addr = 0x4a000000
  '';
in

buildUBoot {
  version = "unstable-2022-03-13";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "u-boot";
    # Last git revision from the `d1-wip` branch:
    rev = "301dc3a3705ea4a5757da9d12ff0744377a2e1a8";
    sha256 = "sha256-QH2US28eFhKWsamxUbj7SVkPLfmE+BQ5lMCUpUzfAW8=";
  };

  defconfig = "lichee_rv_defconfig";
  OPENSBI = "${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin";
  extraMeta.platforms = [ "riscv64-linux" ];

  filesToInstall = [ "u-boot.toc1" ];
  postBuild = ''
    ./tools/mkimage -T sunxi_toc1 -d ${toc1Config} u-boot.toc1
  '';
}
