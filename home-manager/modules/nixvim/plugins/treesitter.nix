{pkgs,lib,...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        languageRegister.nu = "nu";
      };
      treesitter-context.enable = true;
    };
    filetype.extension.nu = "nu";
    extraConfigLua = ''
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.nu = {
        filetype = "nu",
      }
    '';
    keymaps = [
      {mode = "n"; key = "<leader>tc"; action = "<cmd>TSContextToggle<CR>"; options.desc = "Toggle treesitter context";}
    ];
  };
}
