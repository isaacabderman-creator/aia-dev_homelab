{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "isaacabderman@gmail.com";
    certs."aiadev.dedyn.io" = {
      dnsProvider = "desec";
      environmentFile = "/etc/secrets/desec.env";
      group = "adguardhome";
    };
  };
  services.fail2ban = {
    enable = true;
    maxretry = 5;       # failed attempts before ban
    bantime = "1h";     # how long the ban lasts
    bantime-increment = {
      enable = true;    # doubles ban duration on repeat offenders
      multipliers = "2 4 8 16 32 64";
      maxtime = "168h"; # caps at 1 week
    };
    jails.sshd = ''
      enabled = true
      port = 22
      filter = sshd
      maxretry = 3
    '';
  };
}
