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
      "*.aws.smaato*.net,ip-*.compute.internal,ec2-*compute*amazonaws*,*.ec2.internal" = {
        matchType = "host";
        user = "syseng";
        identitiesOnly = true;
        identityFile = "~/.ssh/blessid-cert.pub";
        serverAliveInterval = 20;
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };
      "*.us-east-1.aws.smaatolabs.net,ip-10-168-*.ec2.internal,jenkins-sys.smaatolabs.net,10.168.*" = {
        matchType = "host";
        proxyCommand  = "ssh -W %h:%p bastion-test-us-east-1";
      };
      "*.us-east-1.aws.smaato.net,ip-10-1-*.ec2.internal,grafana.smaato.net,10.1.*" = {
        matchType = "host";
        proxyCommand  = "ssh -W %h:%p bastion-prod-us-east-1";
      };
      "*.eu-west-1.aws.smaato.net,ip-10-6-*.compute.internal,10.6.*" = {
        matchType = "host";
        proxyCommand  = "ssh -W %h:%p bastion-prod-eu-west-1";
      };
      "*.ap-southeast-1.aws.smaato.net,ip-10-4-*.compute.internal,10.4.*" = {
        matchType = "host";
        proxyCommand  = "ssh -W %h:%p bastion-prod-ap-southeast-1";
      };
      "bastion-*" = {
        matchType = "host";
        user = "jump";
        identitiesOnly = true;
        identityFile = "~/.ssh/blessid-cert.pub";
        serverAliveInterval = 20;
        extraOptions = {
          StrictHostKeyChecking = "no";
          UserKnownHostsFile = "/dev/null";
        };
      };
      "bastion-test-us-east-1" = {
        matchType = "host";
        hostname = "smaato-vpc.jump.smaatolabs.net";
      };
      "bastion-prod-us-east-1" = {
        matchType = "host";
        hostname = "vpc-10-1.jump.smaato.net";
      };
      "bastion-prod-eu-west-1" = {
        matchType = "host";
        hostname = "vpc-10-6.jump.smaato.net";
      };
      "bastion-prod-ap-southeast-1" = {
        matchType = "host";
        hostname = "vpc-10-4.jump.smaato.net";
      };
    };
  };

  programs.home-manager.enable = true;
  programs.home-manager.path = "/home/denny-schaefer/workspace/home-manager";
}
