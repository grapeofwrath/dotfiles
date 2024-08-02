{
  inputs,
  outputs,
  pkgs,
  gLib,
  gVar,
  host,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs gLib gVar host;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
