{ nixpkgs ? (import ./sources.nix).nixpkgs }:
let
  this = import ../.;
  pkgs = import nixpkgs {};

in {
  tuxedo-control-center = pkgs.callPackage ./tuxedo-control-center {};

  test = pkgs.nixosTest ({ lib, pkgs, ... }: {
    name = "tuxedo-control-center-test";
    machine = { pkgs, ... }: {
      imports = [
        this.module
      ];

      hardware.tuxedo-control-center.enable = true;
    };

    testScript = ''
      start_all();
      machine.wait_for_unit("tccd.service")
    '';
  });
}
