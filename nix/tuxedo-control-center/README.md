# How to update

1. Bump the version of `tuxedo-control-center` in [packages.json](./packages.json) to the latest on [tuxedocomputers/tuxedo-control-center](https://github.com/tuxedocomputers/tuxedo-control-center)
2. Run `generate-dependencies.sh`
3. Set the version in [default.nix](./default.nix). (Version can be found in [tuxedocomputers/tuxedo-control-center/package.json](https://github.com/tuxedocomputers/tuxedo-control-center/blob/master/package.json))
4. Build and test
