{ pkgs, lib, ... }:

{
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.configurationLimit = 20;

  time.timeZone = "Indian/Antananarivo";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "mg_MG.UTF-8";
    LC_IDENTIFICATION = "mg_MG.UTF-8";
    LC_MEASUREMENT = "mg_MG.UTF-8";
    LC_MONETARY = "mg_MG.UTF-8";
    LC_NAME = "mg_MG.UTF-8";
    LC_NUMERIC = "mg_MG.UTF-8";
    LC_PAPER = "mg_MG.UTF-8";
    LC_TELEPHONE = "mg_MG.UTF-8";
    LC_TIME = "mg_MG.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };

  programs.bash.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/flake#nixos";
  };

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
    # Built from GitHub, not from the user-writable /home/iai checkout: root
    # never builds from a tree an unprivileged process can modify. The lock file
    # is read-only here, so inputs are re-pointed at their release branches at
    # build time. Keep these in step with the URLs in flake.nix when changing
    # release (--update-input would be shorter but is deprecated in Nix).
    flake = "github:isaacabderman-creator/aia-dev_homelab#nixos";
    flags = [
      "--override-input"
      "nixpkgs"
      "github:NixOS/nixpkgs/nixos-26.05"
      "--override-input"
      "nixpkgs-unstable"
      "github:NixOS/nixpkgs/nixos-unstable"
      "--override-input"
      "home-manager"
      "github:nix-community/home-manager/release-26.05"
      "--no-write-lock-file"
    ];
    allowReboot = false;
    persistent = true;
  };

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowSuspendThenHibernate = "no";
    AllowHybridSleep = "no";
  };

  programs.nix-ld.enable = true;
}
