{inputs,config,pkgs,...}: {
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    image = ../../assets/stylix/wallpaper.jpg;
    base16Scheme = ../../assets/stylix/campfire.yaml;
    homeManagerIntegration.autoImport = false;
    fonts = {
      monospace = {
        package = (pkgs.nerdfonts.override {fonts = ["CascadiaCode"];});
        name = "CaskaydiaCove Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
    };
  };
}
