# Installation

- CURL
- CHOWN (work as normal user in the repo)
- LINKING see below

After cloning add a soft link from the git repo to $HOME/.config/nixpkgs

```
ln -s `$(pwd)` ~/.config/nixpkgs
```
