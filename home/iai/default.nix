{ pkgs, ... }:

{
  home.username = "iai";
  home.homeDirectory = "/home/iai";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/flake#nixos";
    };
  };
  programs.git = {
    enable = true;
    settings.user = {
      name = "ANDRIANARIMANANA Isaac Abderman";
      email = "isaacabderman@gmail.com";
    };
  };
}
