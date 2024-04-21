{...}: {
  programs.nixvim = {
    plugins.oil = {
      enable = true;
      settings = {
        view_options.show_hidden = true;
      };
    };
    keymaps = [
      {mode = "n"; key = "-"; action = "<cmd>Oil<CR>"; options.desc = "Open Parent Directory";}
    ];
  };
}
