{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
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
    maxretry = 5;
    bantime = "1h";

    bantime-increment = {
      enable = true;
      multipliers = "2 4 8 16 32 64";
      maxtime = "168h";
    };

    # Use the attribute set (submodule) style instead of a string
    jails.sshd = {
      settings = {
        enabled = true;
        port = 22;
        filter = "sshd";
        maxretry = 3;
        backend = "systemd";
      };
    };
  };
}
