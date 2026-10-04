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
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "full";
      LockPersonality = true;
      RestrictSUIDSGID = true;
    };
  };
}
