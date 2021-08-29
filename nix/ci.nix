{ nixpkgs ? (import ./sources.nix).nixpkgs }:
let
  this = import ../.;
  
  pkgs = import nixpkgs {
    overlays = [
      this.overlay
    ];
  };

in {
  inherit (pkgs) tuxedo-control-center tuxedo-keyboard;

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
