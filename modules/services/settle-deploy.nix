{ config, lib, pkgs, ... }:

# Continuous deployment for settle.
#
# GitHub CI moves each repo's `release` branch only after its tests and Nix build pass.
# Every 3 minutes this checks those branches with read-only deploy keys. When one moved, it
# fetches it into the bare repo (~/<repo>.git, the flake input), builds the system as iai,
# activates it and checks the services:
#   - a failed build changes nothing on the system;
#   - a failed health check rolls back to the previous system;
#   - a failed commit is not retried until a newer one arrives.
#
# Logs: journalctl -u settle-deploy        Run now: sudo systemctl start settle-deploy
let
  user = "iai";
  home = "/home/${user}";
  flake = "${home}/flake";

  deploy = pkgs.writeShellApplication {
    name = "settle-deploy";
    runtimeInputs = with pkgs; [ git openssh coreutils curl util-linux config.nix.package ];
    text = builtins.readFile ./settle-deploy.sh;
    runtimeEnv = { USER_NAME = user; USER_HOME = home; FLAKE = flake; };
  };
in
{
  systemd.services.settle-deploy = {
    description = "Deploy settle from its release branches";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe deploy;
      StateDirectory = "settle-deploy";
      StateDirectoryMode = "0700";
    };
  };

  systemd.timers.settle-deploy = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "2min";
      OnUnitActiveSec = "3min";
      RandomizedDelaySec = "20s";
    };
  };
}
