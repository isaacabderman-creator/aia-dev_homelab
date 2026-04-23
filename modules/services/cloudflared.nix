{ ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "6bfacd18-076f-4aba-90f4-26d41e397d0d" = {
        credentialsFile = "/var/lib/cloudflared/6bfacd18-076f-4aba-90f4-26d41e397d0d.json";
        ingress = {
          "adguard.aialab.tech" = "http://127.0.0.1:3000";
        };
        default = "http_status:404";
      };
    };
  };

  systemd.services.cloudflared.serviceConfig = {
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "strict";
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    StateDirectory = "cloudflared";
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
  };
}
