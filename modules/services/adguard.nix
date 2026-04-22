{ ... }:

{
  services.adguardhome = {
    enable = true;
    host = "0.0.0.0";
    port = 3000;
    settings = {
      users = [{
        name = "admin";
        password = "$2y$05$DbLWZSxVAh1t.uITWs0ZNuV5v3Fde24kiITR8pxyHs8UYE8aLoW4W";
      }];
      dns = {
        upstream_dns = [
          "tls://dns.quad9.net"
          "tls://1dot1dot1dot1.cloudflare-dns.com"
        ];
        parallel_requests = true;
        cache_size = 4194304;
        cache_ttl_min = 600;
      };

      filtering = {
        protection_enabled = true;
        filtering_enabled = true;
        parental_enabled = false;
        safe_search.enabled = false;
      };

      filters =
        map
          (url: {
            enabled = true;
            url = url;
          })
          [
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_3.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_4.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_27.txt"
            "https://adguardteam.github.io/HostlistsRegistry/assets/filter_8.txt"
          ];
    };
  };
}
