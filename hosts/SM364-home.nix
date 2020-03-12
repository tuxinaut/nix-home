{ pkgs, lib, config, ... }:

{
  home.packages = [
    pkgs.fish
    pkgs.bat
    pkgs.fd
    pkgs.flameshot
    pkgs.font-awesome_5
    pkgs.glibcLocales
    pkgs.ponysay
    pkgs.powerline-fonts
    pkgs.ranger
    pkgs.zathura
    pkgs.vimHugeX
    pkgs.parcellite
    pkgs.gimp
    pkgs.terraform
    pkgs.kubectl
    pkgs.ddgr
    pkgs.keepassxc
  ];

  # https://www.linux.com/news/accelerating-openssh-connections-controlmaster
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    controlMaster = "auto";
    controlPath = "/tmp/control_%l_%h_%p_%r";
    controlPersist = "10m";
    extraConfig = "User denny.schaefer";
    matchBlocks = {
      "i-*,mi-*" = {
        matchType = "host";
        user = "syseng";
        proxyCommand  = "sh -c \"aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"";
      };
    };
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = "/home/denny-schaefer/workspace/home-manager";
}
