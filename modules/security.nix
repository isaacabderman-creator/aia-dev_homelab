{ ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "iai" ];
      MaxAuthTries = 3;
      LoginGraceTime = "20s";
      X11Forwarding = false;
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

  boot.kernel.sysctl = {
    "fs.protected_fifos" = 1;
    "fs.protected_hardlinks" = 1;
    "fs.protected_regular" = 1;
    "fs.protected_symlinks" = 1;
    "kernel.dmesg_restrict" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.perf_event_paranoid" = 3;
    "kernel.sysrq" = 0;
    "kernel.unprivileged_bpf_disabled" = 1;
    "kernel.yama.ptrace_scope" = 1;
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.all.send_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.default.send_redirects" = 0;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.ip_forward" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.forwarding" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_source_route" = 0;
    "net.ipv6.conf.default.forwarding" = 0;
  };
}
