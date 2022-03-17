{ lib
, fetchFromGitHub
, stdenv
, python3
}:

stdenv.mkDerivation {
  pname = "sun20i-d1-spl";
  version = "unstable-20220228";

  src = fetchFromGitHub {
    owner = "smaeul";
    repo = "sun20i_d1_spl";
    rev = "0ad88bfdb723b1ac74cca96122918f885a4781ac";
    sha256 = "sha256-4aztbyexULkqbZ2MWRAl8dw9mU8D6z1mllrVchMewJo=";
  };

  buildInputs = [ python3 ];

  buildPhase = ''
    runHook preBuild
    make p=sun20iw1p1 mmc
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    install -Dm444 nboot/boot0_sdcard_sun20iw1p1.bin -t $out/
    runHook postInstall
  '';
}
