# Tuxedo Control Center for NixOS

[![Build](https://github.com/blitz/tuxedo-nixos/actions/workflows/build.yml/badge.svg)](https://github.com/blitz/tuxedo-nixos/actions/workflows/build.yml)

## Overview

This repository provides a Nix derivation for the Tuxedo Control
Center until it is packaged in
[Nixpkgs](https://github.com/NixOS/nixpkgs) (see
[NixOS/nixpkgs#132206](https://github.com/NixOS/nixpkgs/issues/132206)).

[Tuxedo](https://www.tuxedocomputers.com/) is a German laptop
manufacturer that provides Linux-friendly laptops. Their system
control is done via an app called "Tuxedo Control Center" (TCC). This
open source app provides fan control settings among other
things. Without this app, the Tuxedo laptops default to very noisy fan
control settings. It lives on
[Github](https://github.com/tuxedocomputers/tuxedo-control-center).

## Usage

To enable Tuxedo Control Center, add the module and overlay from this
repository to your `/etc/nixos/configuration.nix`.

```nix
{ config, pkgs, ... }:
let
  tuxedo = import (builtins.fetchTarball "https://github.com/blitz/tuxedo-nixos/archive/master.tar.gz");
in {

 # ...

 imports = [
   tuxedo.module
 ];

 hardware.tuxedo.enable = true;
}
```

## Updating

To update to a new version, see the [updating
instructions](./nix/tuxedo-control-center/README.md).
