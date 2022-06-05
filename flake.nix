{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-compat }: {

    defaultPackage.x86_64-linux =
      # Is there a simpler way to whitelist electron?
      (import nixpkgs {
        currentSystem = "x86_64-linux";
        localSystem = "x86_64-linux";
        config = {
          permittedInsecurePackages = [
            "electron-11.5.0"
          ];
        };
      }).pkgs.callPackage ./nix/tuxedo-control-center {};

    nixosModule = import ./nix/module.nix;
  };
}
