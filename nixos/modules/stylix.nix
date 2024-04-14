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
        package = (pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];});
        name = "JetBrainsMono Nerd Font";
      };
      serif = config.stylix.fonts.monospace;
      sansSerif = config.stylix.fonts.monospace;
    };
  };
}
