{pkgs,...}:
pkgs.stdenv.mkDerivation {
  name = "dialog";
  src = pkgs.fetchFromGitHub {
    owner = "joshuakraemer";
    repo = "sddm-theme-dialog";
    rev = "53f81e322f715d3f8e3f41c38eb3774b1be4c19b";
    sha256 = "qoLSRnQOvH3rAH+G1eRrcf9ZB6WlSRIZjYZBOTkew/0=";
  };
  installPhase = ''
    mkdir -p $out/
    cp -R ./* $out/
  '';
}
