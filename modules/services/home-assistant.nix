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
        # cloudflared connects from localhost; LAN hosts must not be able to
        # spoof X-Forwarded-For.
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        ip_ban_enabled = true;
        login_attempts_threshold = 5;
      };
    };
  };
}
