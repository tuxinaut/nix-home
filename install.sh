#!/usr/bin/env bash

# TODO
# Hardware config will be define and imported
# in configuration.nix!

HOST="$(hostname)"
system=$(uname -s)

INSTALL_PATH="/etc/nixos"

if [[ -d $INSTALL_PATH ]]; then
  SOURCE_PATH=$INSTALL_PATH-orig
  mv -v -- $INSTALL_PATH $SOURCE_PATH
  #cp -v -- $INSTALL_PATH-orig/hardware-configuration.nix $INSTALL_PATH
fi

git clone https://github.com/tuxinaut/nix-home.git $INSTALL_PATH
cd $INSTALL_PATH

if [[ ! -e ./hosts/$HOST.nix ]]; then
  cp -v -- $SOURCE_PATH/configuration.nix ./hosts/$HOST.nix
fi

if [[ ! -e ./hosts/$HOST-hardware-configuration.nix ]]; then
  cp -v -- $SOURCE_PATH/hardware-configuration.nix ./hosts/$HOST-hardware-configuration.nix
  # TODO
  # SED for setting the right hardware path
  # Or do it in the right way via nix dsl
fi

ln -s ./hosts/$HOST.nix configuration.nix

ln -s "." "${HOME}/.config/nixpkgs"

exit 0
