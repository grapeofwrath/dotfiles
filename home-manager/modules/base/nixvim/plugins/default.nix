{glib, ...}: {
  imports = glib.scanPaths ./.;
}
# {lib, ...}: let
#   getDir = dir:
#     lib.mapAttrs
#     (file: type:
#       if type == "directory"
#       then getDir "${dir}/${file}"
#       else type)
#     (builtins.readDir dir);
#   files = dir: lib.collect lib.isString (lib.mapAttrsRecursive (path: type: lib.concatStringsSep "/" path) (getDir dir));
#   validFiles = dir:
#     map
#     (file: ./. + "/${file}")
#     (lib.filter
#       (file: lib.hasSuffix ".nix" file && file != "default.nix")
#       (files dir));
# in {imports = validFiles ./.;}

