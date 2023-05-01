{
  description = "A flake for building a Dynamic Devices Hello World";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs = { self, nixpkgs }: {

    defaultPackage.x86_64-linux =
      # Notice the reference to nixpkgs here.
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation {
        name = "dd-helloworld";
        propagatedBuildInputs = [
          (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
            flask
          ]))
        ];

        dontUnpack = true;
        installPhase = "install -Dm755 ${./myapp.py} $out/bin/myapp";
        #src = self;
      };

  };
}
