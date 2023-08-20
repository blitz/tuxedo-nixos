{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-control-center;
  tuxedo-keyboard = config.boot.kernelPackages.tuxedo-keyboard;

  tuxedo-control-center = pkgs.callPackage ./tuxedo-control-center {};
in
{
  options.hardware.tuxedo-control-center = {
    enable = mkEnableOption ''
      Tuxedo Control Center, the official fan and power management UI
      for Tuxedo laptops.

      This module does not offer any hardcoded configuration. So you
      will get the default configuration until you change it in the
      Tuxedo Control Center.
    '';

    package = mkOption {
      type = types.package;
      default = tuxedo-control-center;
      defaultText = "pkgs.tuxedo-control-center";
      description = ''
        Which package to use for tuxedo-control-center.
      '';
    };
  };

  config = mkIf cfg.enable {
    hardware.tuxedo-keyboard.enable = true;
    boot.kernelModules = [
      # Tuxedo Control Center has a requirement on the minimum version
      # of "tuxedo_io" kernel module.
      # The exact requirement is currently in the 
      # "src/native-lib/tuxedo_io_lib/tuxedo_io_ioctl.h" file of tuxedo-control-center
      # (i.e. the #define of MOD_API_MIN_VERSION).
      # The respective version of the module itself is in the 
      # "src/tuxedo_io/tuxedo_io.c" file of tuxedo-keyboard
      # (i.e. the #define of MODULE_VERSION).
      (warnIf
        ((builtins.compareVersions tuxedo-keyboard.version "3.1.2") < 0)
        "Tuxedo Control Center requires at least version 3.1.2 of tuxedo-keyboard (0.2.6 tuxedo_io kernel module); current version is ${tuxedo-keyboard.version}"
        "tuxedo_io")
    ];

    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    # See https://github.com/tuxedocomputers/tuxedo-control-center/issues/148
    nixpkgs.config.permittedInsecurePackages = [
      "electron-13.6.9"
      "nodejs-14.21.3"
      "openssl-1.1.1t"
      "openssl-1.1.1u"
      "openssl-1.1.1v"
    ];

    systemd.services.tccd = {
      path = [ cfg.package ];

      description = "Tuxedo Control Center Service";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/tccd --start";
        ExecStop = "${cfg.package}/bin/tccd --stop";
      };
    };

    systemd.services.tccd-sleep = {
      path = [ cfg.package ];

      description = "Tuxedo Control Center Service (sleep/resume)";

      wantedBy = [ "sleep.target" ];

      unitConfig = {
        StopWhenUnneeded = "yes";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";

        ExecStart = "systemctl stop tccd";
        ExecStop = "systemctl start tccd";
      };
    };
  };
}
