{...}: {
  programs.nixvim.plugins.cmp = {
    enable = true;
    settings = {
      sources = [
        {name = "path";}
        {name = "nvim_lsp";}
        {name = "luasnip";}
        # {name = "crates";}
        {name = "buffer";}
      ];
      mapping = {
        "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        "<C-f>" = "cmp.mapping.scroll_docs(4)";
        "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.abort()";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
      };
      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
    };
  };
}
