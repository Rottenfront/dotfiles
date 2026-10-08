{pkgs ? import <nixpkgs> { }}:

pkgs.mathematica.override {
  source = pkgs.requireFile {
    name = "Mathematica_14.1.0_BNDL_LINUX.sh";
    sha256 = "sha256:1zbcsrrb500izm9n3k91a811pgak406d1ja88xa8blcv18s6lsjc";
    message = ''
      Your override for Mathematica includes a different src for the installer,
      and it is missing.
    '';
    hashMode = "recursive";
  };
}
