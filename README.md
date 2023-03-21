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

To enable Tuxedo Control Center, add the module from this repository
to your `/etc/nixos/configuration.nix`.

### Option 1: Stable Nix

```nix
{ config, pkgs, ... }:
let
  tuxedo = import (builtins.fetchTarball "https://github.com/blitz/tuxedo-nixos/archive/master.tar.gz");
in {

 # ...

 imports = [
   tuxedo.module
 ];

 hardware.tuxedo-control-center.enable = true;
}
```

### Option 2: Nix Flake

This repository is a [Nix Flake](https://nixos.wiki/wiki/Flakes). As
such, it exports its module in a way that makes it somewhat convenient
to use in your Flakes-enabled NixOS configuration.

First enable the module in your `flake.nix`:

```nix
{
  inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

	# ...

	tuxedo-nixos = {
	  url = "github:blitz/tuxedo-nixos";

	  # Avoid pulling in the nixpkgs that we pin in the tuxedo-nixos repo.
	  # This should give the least surprises and saves on disk space.
	  inputs.nixpkgs.follows = "nixpkgs";
	};
  };

  outputs = { self, nixpkgs, tuxedo-nixos }: {
	nixosConfigurations = {
	  your-system = nixpkgs.lib.nixosSystem {

	  # ...

	  modules = [
		./configuration.nix
		tuxedo-nixos.nixosModules.default

		# ...
	  ];

	  # ...

	  };
	};
  };
}
```

Then enable the module in `configuration.nix`:

```nix
  hardware.tuxedo-control-center.enable = true;
```

## Troubleshooting

The Tuxedo Control Center currently requires an outdated Electron
version, which can break your build. There is an [upstream
issue](https://github.com/tuxedocomputers/tuxedo-control-center/issues/148)
that tracks this.

Until this is fixed follow the instructions that the failing build
gives you to workaround the issue.

## Updating

To update to a new version, see the [updating
instructions](./nix/tuxedo-control-center/README.md).
