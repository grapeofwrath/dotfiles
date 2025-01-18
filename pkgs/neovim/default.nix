{pkgs, ...}: let
  c = {
    base = "#14171f";
    surface = "#2a2f3c";
    overlay = "#323848";
    muted = "#3f475a";
    subtle = "#6d7a88";
    highlight = "#97a4af";
    moon = "#ddd7ca";
    text = "#efc164";
    ember = "#f3835d";
    dawn = "#f35955";
    dusk = "#a885c1";
    shore = "#3a8098";
    foam = "#70adc2";
    evergreen = "#468966";
    fern = "#67cc8e";
  };
in {
  config.vim = {
    autocomplete.nvim-cmp = {
      enable = true;
      sourcePlugins = [
        "lspkind"
        "luasnip"
        "none-ls"
        "nvim-lspconfig"
      ];
      sources = {
        buffer = "[Buffer]";
      };
    };
    autopairs.nvim-autopairs.enable = true;
    binds.whichKey.enable = true;
    comments.comment-nvim.enable = true;
    dashboard.alpha.enable = true;
    extraPlugins = with pkgs.vimPlugins; {
      "oil.nvim" = {
        package = oil-nvim;
        setup = ''
          require('oil').setup{
              view_options = {
                  show_hidden = true
              }
          }
        '';
      };
    };
    keymaps = [
      {
        key = "-";
        mode = "n";
        action = ":Oil<CR>";
      }
      {
        key = "<leader>q";
        mode = "n";
        action = "<cmd>qa<CR>";
      }
      {
        key = "<leader>w";
        mode = "n";
        action = "<cmd>w<CR>";
      }
      {
        key = "<leader>wq";
        mode = "n";
        action = "<cmd>wqa<CR>";
      }
    ];
    languages = {
      enableFormat = true;
      enableLSP = true;
      enableTreesitter = true;
      bash.enable = true;
      css.enable = true;
      go.enable = true;
      html.enable = true;
      markdown.enable = true;
      nix.enable = true;
      nu.enable = true;
      odin.enable = true;
      tailwind.enable = true;
      ts.enable = true;
      zig.enable = true;
    };
    lineNumberMode = "relative";
    lsp = {
      formatOnSave = true;
      lspkind.enable = true;
      lsplines.enable = true;
    };
    luaConfigPre = ''
      require("rose-pine").setup({
          styles = {
              bold = true,
              italic = true,
          },
          palette = {
              main = {
                  base = '${c.base}',
                  surface = '${c.surface}',
                  overlay = '${c.overlay}',
                  muted = '${c.muted}',
                  subtle = '${c.subtle}',
                  text = '${c.text}',
                  love = '${c.dawn}',
                  gold = '${c.fern}',
                  rose = '${c.ember}',
                  pine = '${c.dusk}',
                  foam = '${c.foam}',
                  iris = '${c.evergreen}',
              },
          },
      })
    '';
    notes = {
      todo-comments.enable = true;
    };
    options = {
      autoindent = true;
      cursorlineopt = "both";
      shiftwidth = 4;
      tabstop = 4;
    };
    preventJunkFiles = true;
    snippets.luasnip.enable = true;
    syntaxHighlighting = true;
    telescope = {
      enable = true;
      setupOpts.defaults.file_ignore_patterns = [
        "node_modules"
        ".git/"
        "dist/"
        "build"
        "target"
        "result"
        ".direnv/"
      ];
    };
    terminal.toggleterm.enable = true;
    theme = {
      enable = true;
      name = "rose-pine";
      style = "main";
    };
    treesitter = {
      enable = true;
      autotagHtml = true;
      context.enable = true;
    };
    ui = {
      borders = {
        enable = true;
        plugins = {
          lspsaga.enable = true;
          nvim-cmp.enable = true;
          which-key.enable = true;
        };
      };
      colorizer = {
        enable = true;
        setupOpts.filetypes."*" = {
          AARRGGBB = true;
          RGB = true;
          RRGGBB = true;
          RRGGBBAA = true;
          always_update = true;
          css = true;
          hsl_fn = true;
          mode = "background";
          names = true;
          rgb_fn = true;
          sass = true;
          tailwind = true;
          virtualtext = "string";
        };
      };
      noice.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts = {
          colorcolumn = "90";
          disabled_filetypes = [
            "help"
            "html"
            "text"
            "markdown"
            "alpha"
            "telescope"
          ];
        };
      };
    };
    useSystemClipboard = true;
    visuals.nvim-web-devicons.enable = true;
  };
}
