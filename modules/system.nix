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
    flake = "/home/iai/flake#nixos";
    allowReboot = false;
    persistent = true;
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowSuspendThenHibernate=no
    AllowHybridSleep=no
  '';
}
