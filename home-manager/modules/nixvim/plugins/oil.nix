{...}: {
  programs.nixvim = {
    plugins.oil = {
      enable = true;
    };
    keymaps = [
      {mode = "n"; key = "-"; action = "<cmd>Oil<CR>"; options.desc = "Open Parent Directory";}
    ];
  };
}
