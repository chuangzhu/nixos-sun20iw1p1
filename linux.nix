{ fetchFromGitHub
, lib
, stdenv
, linuxKernel
, writeText
, ...
} @ args:

let
  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "linux";
    # Last git revision from the `riscv/d1-wip` branch:
    rev = "06b026a8b7148f18356c5f809e51f013c2494587";
    sha256 = "sha256-eWhbm7phofIVm2zbmTSGDB+gYs21fRbzSyKgqTnSkLM=";
  };
  version = "5.17.0-unstable-2022-02-03";

in

# Not using buildLinux because common-config leads to kernel panic
linuxKernel.manualConfig {
  inherit src version lib;
  modDirVersion = "5.17.0-rc2";
  extraMeta.branch = "riscv/d1-wip";

  # DTB is already loaded from uboot.toc1
  stdenv = stdenv.override (prev: lib.recursiveUpdate prev { hostPlatform.linux-kernel.DTB = false; });

  configfile = ./licheerv.config;
  allowImportFromDerivation = true;
}
