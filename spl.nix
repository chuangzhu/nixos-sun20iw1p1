{ lib
, fetchFromGitHub
, stdenv
, python3
}:

stdenv.mkDerivation {
  pname = "sun20i-d1-spl";
  version = "unstable-2022-04-17";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "sun20i_d1_spl";
    # Last git revision from the `mainline` branch:
    rev = "882671fcf53137aaafc3a94fa32e682cb7b921f1";
    sha256 = "sha256-nvLuUiK1Gqjm8vFhpXrwATMuziPm8wXsFhMUDFdBo3U=";
  };

  nativeBuildInputs = [ python3 ];

  makeFlags = [
    "p=sun20iw1p1"
    "mmc"
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "CROSS_COMPILE=${stdenv.cc.targetPrefix}"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm444 nboot/boot0_sdcard_sun20iw1p1.bin -t $out/
    runHook postInstall
  '';
}
