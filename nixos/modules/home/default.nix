{inputs,outputs,pkgs,...}: {
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
}
