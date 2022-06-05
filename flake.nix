{
  description = "System Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-compat-ci.url = "github:hercules-ci/flake-compat-ci";
  };

  outputs = { self, nixpkgs, flake-compat, flake-compat-ci }: {

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

    # For Hercules CI, which doesn't natively support flakes (yet).
    ciNix = flake-compat-ci.lib.recurseIntoFlakeWith {
      flake = self;

      # Optional. Systems for which to perform CI.
      systems = [ "x86_64-linux" ];
    };
  };
}
