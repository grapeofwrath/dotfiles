{lib,...}: with lib;
let
  # Recursively constructs an attrset of a dir, value of attrs is the filetype
  getDir = dir: mapAttrs
    (file: type: if type == "directory" then getDir "${dir}/${file}" else type)
    (builtins.readDir dir);
  # Collects all files of a dir as list of strs of paths
  files = dir: collect isString (mapAttrsRecursive (path: type: concatStringsSep "/" path) (getDir dir));
  # Filters out dirs != *.nix, makes the strs absolute
  validFiles = dir: map
    (file: ./. + "/${file}")
    (filter
      (file: hasSuffix ".nix" file && file != "default.nix")
      (files dir));
in { imports = validFiles ./.; }
