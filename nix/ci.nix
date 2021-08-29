{ nixpkgs ? (import ./sources.nix).nixpkgs }:
let
  pkgs = import nixpkgs {};
in {
  tuxedo-control-center = pkgs.callPackage ./tuxedo-control-center {};
}
