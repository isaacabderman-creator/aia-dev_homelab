{ ... }:

{
  networking.hostName = "nixos";
  networking.useDHCP = false;

  networking.interfaces.enp3s0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "192.168.1.50";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = "192.168.1.254";
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
  ];
  # enp3s0 is deliberately not a trusted interface: the LAN only reaches the
  # ports listed here (SSH, DNS, Home Assistant + its mDNS/SSDP discovery).
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      53
      8123
    ];
    allowedUDPPorts = [
      53
      1900
      5353
    ];
    checkReversePath = "loose";
    # Home Assistant's UPnP integration talks to the router (the gateway), which
    # sends event callbacks to ephemeral ports on this host. Allow the gateway
    # only; every other LAN host stays limited to the ports above.
    extraCommands = ''
      iptables -A nixos-fw -s 192.168.1.254 -p tcp -j nixos-fw-accept
    '';
  };
  systemd.network.links."10-enp3s0" = {
    matchConfig.Name = "enp3s0";
    linkConfig.GenericReceiveOffload = false;
  };
}
