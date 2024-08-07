{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  dayScheme = "catppuccin-latte";
  nightScheme = "catppuccin-macchiato";
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = lib.mkDefault "macchiato";
      };
      withNodeJs = true;
      extraPackages = with pkgs; [ nodejs-slim ];
      highlightOverride.SpellBad.bg = "#444444";
      autoCmd = [
        {
          event = [ "VimResized" ];
          callback = "function() vim.cmd([[wincmd =]]) end";
        }
      ];
      userCommands = {
        Day = {
          command = "lua vim.cmd([[colorscheme " + dayScheme + "]])";
          nargs = 0;
        };
        Night = {
          command = "lua vim.cmd([[colorscheme " + nightScheme + "]])";
          nargs = 0;
        };
      };
      keymaps = [
        {
          mode = [ "v" ];
          key = "<C-A-c>";
          action = "\"+y";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          mode = [ "n" ];
          key = "ff";
          action.__raw = "function() require('telescope.builtin').find_files() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "fg";
          action.__raw = "function() require('telescope.builtin').live_grep() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "fb";
          action.__raw = "function() require('telescope.builtin').buffers() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "gd";
          action.__raw = "function() vim.lsp.buf.definition() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "gD";
          action.__raw = "function() vim.lsp.buf.declaration() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "gv";
          action.__raw = "function() vim.cmd('vsplit'); vim.lsp.buf.definition() end";
          options = {
            noremap = true;
            silent = true;
          };
        }
        {
          mode = [ "n" ];
          key = "gl";
          action.__raw = "function() vim.diagnostic.open_float() end";
          options = {
            noremap = true;
            silent = true;
          };
        }
      ];
      globals = {
        clipboard = {
          name = "wl-clipboard";
          copy = {
            "+" = "wl-copy --trim-newline";
            "*" = "wl-copy --trim-newline";
          };
          paste = {
            "+" = "wl-paste";
            "*" = "wl-paste";
          };
          cache_enabled = 0;
        };
      };
      opts = {
        compatible = false;
        ignorecase = true;
        showmatch = true;
        hlsearch = true;
        incsearch = true;
        tabstop = 2;
        softtabstop = 0;
        shiftwidth = 2;
        autoindent = true;
        expandtab = false;
        number = true;
        relativenumber = true;
        wildmode = "longest,list";
        syntax = "on";
        ttyfast = true;
        swapfile = false;
        mouse = "a";
        termguicolors = true;
        spell = true;
        spelllang = "en"; # fr
      };
      plugins = {
        lsp-format = {
          enable = true;
        };
        lsp = {
          enable = true;
          servers = {
            nil-ls = {
              enable = true;
              settings.autoformat = true;
            };
            gopls.enable = true;
            svelte.enable = true;
            tsserver.enable = true;
            tailwindcss.enable = true;
            clangd.enable = true;
            lua-ls = {
              enable = true;
              settings = {
                diagnostics = {
                  enable = true;
                  globals = [
                    "vim"
                    "require"
                  ];
                };
                telemetry.enable = false;
              };
            };
            pyright = {
              enable = true;
              settings = {
                venvPath = "env";
              };
            };
            ltex = {
              enable = true;
              settings = {
                filetypes = [ "." ];
                ltex = {
                  language = "en-GB";
                  additionalRules = {
                    languageModel = "~/models/ngrams/";
                  };
                };
              };
            };
            marksman.enable = true;
          };
        };
        conform-nvim = {
          enable = true;
          formattersByFt = {
            lua = [ "stylua" ];
            python = [ "black" ];
            javascript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            typescript = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            svelte = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            html = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            css = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            md = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            less = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            scss = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            json = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            yaml = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            toml = [
              [
                "prettierd"
                "prettier"
              ]
            ];
            java = [ "google-java-format" ];
            nix = [ "nixfmt" ];
            c = [ "clang-format" ];
            go = [ "gofmt" ];
          };
          formatOnSave = {
            lspFallback = true;
            timeoutMs = 1000;
          };
          notifyOnError = true;
          logLevel = "info";
        };
        cmp = {
          enable = true;
          settings = {
            autoEnableSources = true;
            experimental = {
              ghost_text = true;
            };
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 30;
            };
            snippet.expand = "luasnip";
            formatting.fields = [
              "kind"
              "abbr"
              "menu"
            ];
            sources = [
              { name = "nvim_lsp"; }
              { name = "emoji"; }
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
              }
              { name = "copilot"; }
              {
                name = "path"; # file system paths
                keywordLength = 3;
              }
              {
                name = "luasnip"; # snippets
                keywordLength = 3;
              }
            ];
            mapping = {
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
          };
        };
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;
        cmp_luasnip.enable = true;
        cmp-emoji.enable = true;
        copilot-cmp.enable = true;
        copilot-lua = {
          enable = true;
          suggestion.enabled = false;
          panel.enabled = false;
        };
        nvim-colorizer.enable = true;
        ts-autotag.enable = true;
        nvim-autopairs.enable = true;
        treesitter = {
          enable = true;
          nixGrammars = true;
          folding = false;
          grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            go
            lua
            vim
            vimdoc
            sql
            json
            javascript
            typescript
            svelte
            html
            java
            markdown
            nix
            c
            cpp
          ];
          settings.highlight.enable = true;
        };
        telescope = {
          enable = true;
          settings = {
            defaults = {
              file_ignore_patterns = [
                "^.git/"
                "^.mypy_cache/"
                "^__pycache__/"
                "^output/"
                "^data/"
                "%.ipynb"
                "^node_modules/"
                "^venv/"
                "^env/"
              ];
            };
          };
        };
        nvim-tree = {
          enable = true;
          disableNetrw = true;
          openOnSetup = true;
          openOnSetupFile = true;
          autoClose = true;
          diagnostics = {
            enable = true;
            showOnDirs = true;
          };
        };
      };
    };
  };
}
