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
  ];


  # https://www.linux.com/news/accelerating-openssh-connections-controlmaster
  programs.ssh = {
    enable = true;
    forwardAgent = true;
    controlMaster = "yes";
    controlPath = "~/.ssh/master-%r@%h:%p";
    extraConfig = "User denny.schaefer";
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = https://github.com/rycee/home-manager/archive/master.tar.gz;
}
