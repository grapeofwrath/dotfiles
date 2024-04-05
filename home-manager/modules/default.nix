{...}: {
  imports = [
    # using libgrape to import subdirs as modules when home manager
    # is a nixos module causes inifinite recursion
    #libgrape.allSubdirs ./.
    ./base
    ./cli
    ./desktop
    ./shell
  ];
}
