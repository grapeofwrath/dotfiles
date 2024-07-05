{
  libgrape,
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs libgrape;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
