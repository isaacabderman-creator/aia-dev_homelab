{ pkgs, ... }:
{
  # Secrets (AUTH_PASSWORD_HASH, SESSION_SECRET) live in /home/iai/skill-plan.env,
  # outside the Nix store. Create it with: node scripts/set-password.mjs
  systemd.services.skill-plan = {
    description = "Skill plan course reader";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    environment = {
      HOST = "127.0.0.1";
      COOKIE_SECURE = "1";
      PORT = "8000";
    };
    serviceConfig = {
      User = "iai";
      WorkingDirectory = "/home/iai/skill-plan";
      EnvironmentFile = "/home/iai/skill-plan.env";
      ExecStart = "${pkgs.nodejs_22}/bin/node server.js";
      Restart = "on-failure";
      # The app runs as iai (it owns the tree, its SQLite db and the lessons it
      # creates), but sees an empty /home except its own folder, so a compromise
      # cannot read ~/.ssh, ~/.config (gh/copilot tokens) or ~/flake.
      ProtectHome = "tmpfs";
      BindPaths = [ "/home/iai/skill-plan" ];
      ProtectSystem = "strict";
      ReadWritePaths = [ "/home/iai/skill-plan" ];
      NoNewPrivileges = true;
      PrivateTmp = true;
      PrivateDevices = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectKernelLogs = true;
      ProtectControlGroups = true;
      ProtectClock = true;
      ProtectProc = "invisible";
      ProcSubset = "pid";
      CapabilityBoundingSet = "";
      LockPersonality = true;
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
      RestrictNamespaces = true;
      RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
      SystemCallArchitectures = "native";
      SystemCallFilter = [ "@system-service" "~@privileged" ];
      # MemoryDenyWriteExecute stays off: V8's JIT needs writable+executable pages.
    };
  };
  security.sudo.extraRules = [{
    users = [ "iai" ];
    commands = [{
      command = "/run/current-system/sw/bin/systemctl restart skill-plan";
      options = [ "NOPASSWD" ];
    }];
  }];
}
