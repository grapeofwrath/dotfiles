{lib, ...}: {
  allSubdirs = rootPath: let
    readset = builtins.readDir rootPath;
    dirset = lib.filterAttrs (_: type: type == "directory") readset;
    dirs = map (lib.path.append rootPath) (builtins.attrNames dirset);
  in
    dirs;
  scanPaths = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (lib.attrsets.filterAttrs
        (
          path: _type:
            (_type == "directory")
            || (
              (path != "default.nix")
              && (lib.strings.hasSuffix ".nix" path)
            )
        )
        (builtins.readDir path)));
  scanFiles = path:
    builtins.map
    (f: (path + "/${f}"))
    (builtins.attrNames
      (builtins.readDir path));
}
