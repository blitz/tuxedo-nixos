{ nixpkgs ? (import ./sources.nix).nixpkgs }:
let
  pkgs = import nixpkgs {};

  tuxedo-control-center = pkgs.callPackage ./tuxedo-control-center {};
in {
  inherit tuxedo-control-center;

  test = pkgs.nixosTest ({ lib, pkgs, ... }: {
    name = "tuxedo-control-center-test";
    machine = { pkgs, ... }: {
      imports = [
        ./module.nix
      ];

      nixpkgs.overlays = [
        (final: prev: { inherit tuxedo-control-center; })
      ];

      hardware.tuxedo-control-center.enable = true;
    };

    testScript = ''
      start_all();
      machine.wait_for_unit("tccd.service")
    '';
  });
}
