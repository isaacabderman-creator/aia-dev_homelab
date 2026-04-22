{ config, pkgs, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "6bfacd18-076f-4aba-90f4-26d41e397d0d" = {
        credentialsFile = "/home/iai/.cloudflared/6bfacd18-076f-4aba-90f4-26d41e397d0d.json";
        ingress = {
          "dns.aialab.tech" = "http://localhost:3000";
        };
        default = "http_status:404";
      };
    };
  };
}
