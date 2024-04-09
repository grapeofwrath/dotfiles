{inputs,config,lib,...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    image = ./wallpaper.jpg;
    base16Scheme = ./campfire.yaml;
  };
}
