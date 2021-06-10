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
        package = unstable.virtualbox;
        enable = true;
        enableExtensionPack = true;
      };
    };
  };
}
