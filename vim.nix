{ pkgs, lib, config, ... }:

let
  loadPlugin = plugin: ''
    set rtp^=${plugin.rtp}
    set rtp+=${plugin.rtp}/after
  '';

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
    syntastic
    fugitive
    nerdtree
    ctrlp
    #vim-gnupg
    vim-airline
    #SudoEdit.vim
    vim-multiple-cursors
    surround
    editorconfig-vim
    vim-better-whitespace
    #Dockerfile.vim
    #Vim-Jinja2-Syntax
    neocomplete
    neosnippet
    neosnippet-snippets
    vim-snippets
    vim-airline-themes
    molokai
    tagbar
    vim-quick-scope
  ];

  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
in
{

  home.packages = [
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
}
