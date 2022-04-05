{ lib, stdenv, fetchFromGitHub, kernel, bc }:

stdenv.mkDerivation rec {
  pname = "rtl8723bs";
  version = "${kernel.version}-unstable-2022-02-06";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtl8723ds";
    rev = "76fb80685be9920a1d5ac7003102dcdfb76daa6b";
    sha256 = "sha256-QUkUsSFnkmRIRawYYJ2NB2C+VB2PZoF6C0ZJkdm6IMQ=";
  };

  hardeningDisable = [ "pic" ];

  nativeBuildInputs = [ bc ];
  buildInputs = kernel.moduleBuildDependencies;

  makeFlags = [ "ARCH=${stdenv.hostPlatform.linuxArch}" ];

  prePatch = ''
    substituteInPlace ./Makefile \
      --replace /lib/modules/ "${kernel.dev}/lib/modules/" \
      --replace '$(shell uname -r)' "${kernel.modDirVersion}" \
      --replace /sbin/depmod \# \
      --replace '$(MODDESTDIR)' "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  preInstall = ''
    mkdir -p "$out/lib/modules/${kernel.modDirVersion}/kernel/net/wireless/"
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Linux driver for RTL8723DS.";
    homepage = "https://github.com/lwfinger/rtl8723ds";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
}
