# allow our nixpkgs import to be overridden if desired
{ pkgs ? import <nixpkgs> { } }:

# let's write an actual basic derivation
# this uses the standard nixpkgs mkDerivation function
pkgs.stdenv.mkDerivation {

  # name of our derivation
  name = "dd-helloworld";

  propagatedBuildInputs = [
    (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
      flask
    ]))
  ];

  dontUnpack = true;
  installPhase = "install -Dm755 ${./myapp.py} $out/bin/myapp";
}
