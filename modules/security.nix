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

  services.gnome-keyring = {
    enable = true;
  };
}
