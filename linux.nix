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
    rev = "cc63db754b218d3ef9b529a82e04b66252e9bca1";
    sha256 = "sha256-HDmubvHgsAEmdyNKpVotWbGvLhnuEbpAths6vVME8mQ=";
  };
  version = "5.18.0-unstable-2022-04-06";

in

# Not using buildLinux because common-config leads to kernel panic
linuxKernel.manualConfig {
  inherit src version lib;
  modDirVersion = "5.18.0-rc1";
  extraMeta.branch = "riscv/d1-wip";

  # DTB is already loaded from uboot.toc1
  stdenv = stdenv.override (prev: lib.recursiveUpdate prev { hostPlatform.linux-kernel.DTB = false; });

  configfile = ./config.nezha;
  allowImportFromDerivation = true;
}
