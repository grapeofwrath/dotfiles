{inputs,outputs,pkgs,...}: {
  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager.extraSpecialArgs = {inherit inputs outputs;};
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users = {
    grape = {
      # imports = [../../../home-manager/grape/${config.networking.hostName}.nix];
      home = {
        username = "grape";
        homeDirectory = "/home/grape";
        stateVersion = "23.11";
      };
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;
    };
  };
}
