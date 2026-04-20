{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/networking.nix
    ../../modules/security.nix
    ../../modules/services/adguard.nix
    ../../modules/services/ddclient.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.iai = {
    isNormalUser = true;
    description = "ANDRIANARIMANANA Isaac Abderman";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  users.groups.adguardhome = { };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    dig
    cloudflared
    tree
    btop
  ];

  system.stateVersion = "25.11";
}
