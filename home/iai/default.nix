{ pkgs, unstable, ... }:

{
  home.username = "iai";
  home.homeDirectory = "/home/iai";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    nodejs
    nixpkgs-fmt
    tcpdump
    traceroute
    unstable.github-copilot-cli
    gh
  ];

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "ANDRIANARIMANANA Isaac Abderman";
        email = "isaacabderman@gmail.com";
      };
      core.hooksPath = ".githooks";
    };
  };
}
