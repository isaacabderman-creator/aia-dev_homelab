{ ... }:

{
  networking.hostName = "nixos";
  networking.useDHCP = false;

  networking.interfaces.enp3s0 = {
    useDHCP = false;
    ipv4.addresses = [{
      address = "192.168.1.50";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = "192.168.1.254";
  networking.nameservers = [ "8.8.8.8" "1.1.1.1" ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 853 3000 ];
    allowedUDPPorts = [ 53 ];
  };
}
