# Home-manager module for Parler speech-to-text
#
# Provides a systemd user service for autostart.
# Usage: imports = [ parler.homeManagerModules.default ];
#        services.parler.enable = true;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.parler;
in
{
  options.services.parler = {
    enable = lib.mkEnableOption "Parler speech-to-text user service";

    package = lib.mkOption {
      type = lib.types.package;
      defaultText = lib.literalExpression "parler.packages.\${system}.parler";
      description = "The Parler package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.parler = {
      Unit = {
        Description = "Parler speech-to-text";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${cfg.package}/bin/parler";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
