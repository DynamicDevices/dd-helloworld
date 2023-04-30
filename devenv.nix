{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/eabc38219184cc3e04a974fe31857d8e0eac098d.tar.gz") { }, ... }:
#{ pkgs, ... }:

{
  # https://devenv.sh/basics/
  env.GREET = "DevEnv has been loaded";

  # https://devenv.sh/packages/
  packages = [
    pkgs.git
  ];

  enterShell = ''
    hello
  '';

  # https://devenv.sh/languages/
  languages.nix.enable = true;
  languages.python = {
    enable = true;
    poetry.enable = true;
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = "echo $GREET";

  # https://devenv.sh/pre-commit-hooks/
  pre-commit.hooks = {
    shellcheck.enable = true;
    nixpkgs-fmt.enable = true;
    statix.enable = true;
  };
  pre-commit.excludes = [ "\\.devenv.*" ];

  # https://devenv.sh/processes/
  processes.test-server.exec = "(poetry run python myapp.py &)";
}
