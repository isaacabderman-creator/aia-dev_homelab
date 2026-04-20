{ ... }:

{
  services.ddclient = {
    enable = true;
    interval = "5min";
    protocol = "dyndns2";
    server = "update.dedyn.io";
    ssl = true;
    username = "aiadev.dedyn.io";
    passwordFile = "/etc/secrets/desec-token";
    domains = [ "aiadev.dedyn.io" ];
  };
}
