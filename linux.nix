{ buildLinux
, fetchFromGitHub
, lib
, ...
} @ args:

buildLinux (args // rec {

  version = "5.17.0-unstable-2022-02-03";
  modDirVersion = "5.17.0-rc2";
  extraMeta.branch = "riscv/d1-wip";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "linux";
    # Last git revision from the `riscv/d1-wip` branch:
    rev = "06b026a8b7148f18356c5f809e51f013c2494587";
    sha256 = "sha256-eWhbm7phofIVm2zbmTSGDB+gYs21fRbzSyKgqTnSkLM=";
  };
  kernelPatches = [ ];

  defconfig = "nezha_defconfig";
  # Fixes `repeated question:   Low (Up to 2x) density storage for compressed pages at generate-config.pl line 88.`
  structuredExtraConfig.ZBUD = lib.mkForce lib.kernel.module;

} // (args.argsOverride or { }))
