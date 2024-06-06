{...}: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;
        servers = {
          lua-ls.enable = true;
          marksman.enable = true;
          #nil_ls.enable = true;
          nushell.enable = true;
          pylsp.enable = true;
          yamlls.enable = true;
          gopls.enable = true;
          htmx.enable = true;
          html.enable = true;
          nixd.enable = true;
          cssls.enable = true;
          ccls.enable = true;
          bashls.enable = true;
          astro.enable = true;
        };
      };
      lspkind = {
        enable = true;
      };
      nix.enable = true;
      none-ls.enable = true;
      lsp-lines.enable = true;
      lspsaga = {
        enable = true;
        lightbulb = {
          enable = false;
        };
        symbolInWinbar.enable = false;
        ui.border = "rounded";
      };
      luasnip.enable = true;
    };
    keymaps = [
      {mode = "n"; key = "<leader>ll"; action = "<cmd>lua require('lsp_lines').toggle()<CR>"; options.desc = "Toggle Lines";}
      {mode = "n"; key = "<leader>la"; options.desc = "Lsp Code Actions"; action = "<cmd>Lspsaga code_action<CR>";}
      {mode = "n"; key = "<leader>lf"; options.desc = "Lsp Find"; action = "<cmd>Lspsaga finder<CR>";}
      {mode = "n"; key = "<leader>lh"; options.desc = "Lsp Hover"; action = "<cmd>Lspsaga hover_doc<CR>";}
      {mode = "n"; key = "<leader>lr"; options.desc = "Lsp Rename"; action = "<cmd>Lspsaga rename<CR>";}
      {mode = "n"; key = "<leader>lp"; options.desc = "Lsp Show Definition"; action = "<cmd>Lspsaga peek_definition<CR>";}
      {mode = "n"; key = "<leader>ld"; options.desc = "Lsp Goto Definition"; action = "<cmd>Lspsaga goto_definition<CR>";}
      {mode = "n"; key = "<leader>lt"; options.desc = "Lsp toggle terminal"; action = "<cmd>Lspsaga term_toggle<CR>";}
    ];
    autoCmd = [
      {event = "VimEnter"; command = "lua require('lsp_lines').toggle()";}
    ];
  };
}
