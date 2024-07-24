{
  inputs,
  outputs,
  pkgs,
  glib,
  host,
  username,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs glib username host;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
