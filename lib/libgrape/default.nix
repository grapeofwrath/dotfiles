{ lib }: {
  allSubdirs = rootPath:
    let
      # { "file-or-dir-name" = "regular|directory" ... }
      readset = builtins.readDir rootPath;
      dirset = lib.filterAttrs (_: type: type == "directory") readset;
      dirs = map (lib.path.append rootPath) (builtins.attrNames dirset);
    in dirs;
  allNixFiles = rootPath:
    let
      # { "file-or-dir-name" = "regular|directory" ... }
      readset = builtins.readDir rootPath;
      isNixFile = lib.strings.hasSuffix ".nix";
      fileset = lib.filterAttrs (filename: type: (isNixFile filename) && type == "regular") readset;
      files = map (lib.path.append rootPath) (builtins.attrNames fileset);
    in files;
  existsOr = a: b: if a == null then b else a;
}
