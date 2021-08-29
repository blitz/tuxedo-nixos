{ nixpkgs ? (import ./sources.nix).nixpkgs }:
let
  pkgs = import nixpkgs {
    overlays = [
      (import ./overlay.nix)
    ];
  };

in {
  inherit (pkgs) tuxedo-control-center tuxedo-keyboard;

  test = pkgs.nixosTest ({ lib, pkgs, ... }: {
    name = "tuxedo-control-center-test";
    machine = { pkgs, ... }: {
      imports = [
        ./module.nix
      ];

      hardware.tuxedo-control-center.enable = true;
    };

    testScript = ''
      start_all();
      machine.wait_for_unit("tccd.service")
    '';
  });
}
