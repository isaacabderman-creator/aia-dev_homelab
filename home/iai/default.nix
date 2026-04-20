{ pkgs, ... }:

{
  home.username = "iai";
  home.homeDirectory = "/home/iai";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    github-copilot-cli
  ];

  programs.git = {
    enable = true;
    settings.user = {
      name = "ANDRIANARIMANANA Isaac Abderman";
      email = "isaacabderman@gmail.com";
    };
  };

  services.gnome-keyring = {
    enable = true;
  };
}
