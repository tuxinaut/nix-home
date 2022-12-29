let
  unstable = import <nixos-unstable> {};
in
{
  # Enable virtualbox.
  virtualisation = {
#    docker = {
#      enable = true;
#    };
    virtualbox = {
      host = {
        package = pkgs.virtualbox;
        enable = true;
        enableExtensionPack = true;
      };
    };
  };
}
