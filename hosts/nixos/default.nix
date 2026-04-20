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
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMiAFsCmkR4YBF8v/RoC3cWdTKyYupafp9Cpqpcs+oJw victus"];
  };

  users.groups.adguardhome = { };

  environment.systemPackages = with pkgs; [
    neovim
    wget
    dig
    nixfmt
    cloudflared
    tree
    btop
  ];

  nix.gc = {
  automatic = true;
  dates = "weekly";      
  options = "--delete-older-than 30d";
};

  services.gnome.gnome-keyring.enable = true;

  system.stateVersion = "25.11";
}
