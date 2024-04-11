{inputs,config,lib,...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    image = ../../assets/stylix/wallpaper.jpg;
    base16Scheme = ../../assets/stylix/campfire.yaml;
    homeManagerIntegration.autoImport = false;
  };
}
