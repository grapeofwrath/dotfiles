{pkgs,lib,...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        nixvimInjections = true;
        languageRegister.nu = "nu";
        grammarPackages = with pkgs; [
          tree-sitter-grammars.tree-sitter-nu
          tree-sitter-grammars.tree-sitter-yaml
          tree-sitter-grammars.tree-sitter-vim
          tree-sitter-grammars.tree-sitter-templ
          tree-sitter-grammars.tree-sitter-sql
          tree-sitter-grammars.tree-sitter-python
          tree-sitter-grammars.tree-sitter-nix
          tree-sitter-grammars.tree-sitter-lua
          tree-sitter-grammars.tree-sitter-json
          tree-sitter-grammars.tree-sitter-html
          tree-sitter-grammars.tree-sitter-go
          tree-sitter-grammars.tree-sitter-css
          tree-sitter-grammars.tree-sitter-cpp
          tree-sitter-grammars.tree-sitter-bash
        ];
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
