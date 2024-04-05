{libgrape,inputs,outputs,config,pkgs,...}: {
  imports = [inputs.home-manager.nixosModules.home-manager];
  users = {
    # mutableUsers = false;

    users.grape = {
      isNormalUser = true;
      home = "/home/grape";
      group = "users";
      extraGroups = [ "wheel" "networkmanager" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = [
    inputs.home-manager.packages.${pkgs.system}.default
  ];
  home-manager = {
    users.grape = import ../../../home-manager/homes/grape/${config.networking.hostName};
    extraSpecialArgs = {inherit inputs outputs libgrape;};
    useUserPackages = true;
    useGlobalPkgs = true;
  };
}
