{ ... }:

{
  services.home-assistant = {
    enable = true;
    extraComponents = [
      "upnp"
      "ssdp"
      "zeroconf"
    ];
    extraPackages = python3Packages: with python3Packages; [
      zlib-ng
      pillow
      aiohttp-fast-zlib
    ];
    config = {
      default_config = { };
      http = {
        server_port = 8123;
        use_x_forwarded_for = true;
        trusted_proxies = [
          "127.0.0.1"
          "::1"
          "192.168.1.0/24"
        ];
      };
    };
  };
}
