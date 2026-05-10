{ ... }:
{
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--advertise-exit-node" ];
  };
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ 41641 ];
}
