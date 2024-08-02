{
  glib,
  ...
}: {
    hostNames = glib.allSubdirs ./nixos/systems;
    username = "marcus";
}
