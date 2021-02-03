{ pkgs, lib, config, ... }:

let
  vim-quick-scope = pkgs.vimUtils.buildVimPlugin {
    name = "quick-scope";
    src = pkgs.fetchFromGitHub {
      owner = "unblevable";
      repo = "quick-scope";
      rev= "994576d997a52b4c7828149e9f1325d1c4691ae2";
      sha256= "0lr27vwv2bzva9s7f9d856vvls10icwli0kwj5v5f1q8y83fa4zd";
    };

    buildInputs = [ pkgs.zip pkgs.vim ];
  };

  # See https://nixos.wiki/wiki/Vim
  my_vim_configurable = pkgs.vim_configurable.override {
    python = pkgs.python37Full;
  };

  my_vimPlugins = with pkgs.vimPlugins; [
    iceberg-vim
    Tabular
    vim-indent-guides
    #syntastic
    fugitive
    nerdtree
    ctrlp
    #vim-gnupg
    vim-airline
    #SudoEdit.vim
    #vim-multiple-cursors
    surround
    editorconfig-vim
    vim-better-whitespace
    #Dockerfile.vim
    #Vim-Jinja2-Syntax
    #neocomplete
    #neosnippet
    #neosnippet-snippets
    #vim-snippets
    vim-airline-themes
    molokai
    tagbar
    vim-quick-scope
  ];

  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in
{
  home.packages = [
    # This should be done by
    # https://github.com/LnL7/nix-darwin/blob/master/modules/programs/bash/default.nix
    # pkgs.bash-completion
    pkgs.nix-bash-completions
    pkgs.git
    pkgs.bat
    pkgs.hstr
    pkgs.htop
    pkgs.awscli2
    pkgs.zathura
          (
        my_vim_configurable.customize {
          name = "vim";
          vimrcConfig.packages.myVimPackage = {
            start = my_vimPlugins;
          };

          vimrcConfig.customRC = ''
            ${ (builtins.readFile ../vim/vimrc) }
          '';
      })
  ];

    programs.git = {
      enable = true;
      userName = "Schäfer, Denny";
      userEmail = "denny.schaefer@immowelt.de";
      extraConfig = {
        color.ui = "auto";
        core.editor = "vim";
        core.excludesfile = "~/.gitignore";
      };
    };

    home.file = {
      ".gitignore".source = ../gitignore;
      ".profile".source = ../bash/mac_profile;
      ".bashrc".source = ../bash/mac_bashrc;
      ".config/limelight/limelightrc".source = ../limelightrc;
      ".vim/backup/.dummy".source = ../bash/emptyfile;
      ".vim/swap/.dummy".source = ../bash/emptyfile;
      ".vim/undo/.dummy".source = ../bash/emptyfile;
      "bin/move-window-left-or-right-and-follow-focus".source = ../yabai/move-window-left-or-right-and-follow-focus;
    };

    programs.home-manager = {
      enable = true;
      path = https://github.com/nix-community/home-manager/archive/master.tar.gz;
    };
}
