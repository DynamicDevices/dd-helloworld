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
  processes.test-server = {

    exec = (pkgs.writeShellScript "complex-process" ''
      _rc=0
      echo Running flask server
      poetry run python myapp.py &
      _pid=$!
      sleep 2
      echo Checking server
      curl http://127.0.0.1:5000 | awk '!/^{\"message\":\"Hello, Nix!\"}/ { print $0; rc=1 } END { exit rc }' || _rc=1
      sleep 2
      echo Killing flask server
      kill $_pid
      exit $_rc
    '').outPath;
  };
}
