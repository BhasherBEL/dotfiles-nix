{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  nvimcfg = config.modules.nvim;

  dayScheme = "catppuccin-latte";
  nightScheme = "catppuccin-macchiato";
in
{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  options = {
    modules.nvim.enable = lib.mkEnableOption "Enable neovim";
  };

  config = lib.mkIf nvimcfg.enable {
    #home.packages = with pkgs; [ nerdfonts ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      colorschemes.catppuccin = {
        enable = true;
        settings.flavour = lib.mkDefault "macchiato";
      };
      withNodeJs = true;
      extraPackages = with pkgs; [ nodejs-slim ];
      highlightOverride.SpellBad.bg = "#444444";
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
          key = "fd";
          action.__raw = "function() require('telescope.builtin').diagnostics() end";
          options = { };
        }
        {
          mode = [ "n" ];
          key = "fh";
          action.__raw = "function() require('telescope.builtin').oldfiles() end";
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
        foldlevel = 999;
        foldmethod = "manual";
      };
      plugins = {
        lsp-format = {
          enable = true;
        };
        lsp = {
          enable = true;
          servers = {
            nil_ls = {
              enable = true;
              settings.autoformat = true;
            };
            gopls.enable = true;
            svelte.enable = true;
            ts_ls = {
              enable = true;
              extraOptions = {
                codeActionsOnSave = {
                  "source.organizeImports" = true;
                };
                commands = {
                  OrganizeImports.__raw = ''
                    {
                      function()
                        vim.lsp.buf.execute_command {
                          title = "",
                          command = "_typescript.organizeImports",
                          arguments = { vim.api.nvim_buf_get_name(0) },
                        }
                      end,
                      description = "Organize Imports",
                    }
                  '';
                };
              };
            };
            tailwindcss.enable = true;
            clangd.enable = true;
            lua_ls = {
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
          settings = {
            format_on_save = {
              lspFallback = true;
              timeoutMs = 1000;
            };
            formatters_by_ft =
              let
                prettier = {
                  __unkeyed-1 = "prettierd";
                  __unkeyed-2 = "prettier";
                  stop_after_first = true;
                };
              in
              {
                lua = [ "stylua" ];
                python = {
                  __unkeyed-1 = "black";
                  timeout_ms = 10000;
                };
                javascript = prettier;
                typescript = prettier;
                svelte = prettier;
                html = prettier;
                css = prettier;
                md = prettier;
                less = prettier;
                scss = prettier;
                json = prettier;
                yaml = prettier;
                toml = prettier;
                java = [ "google-java-format" ];
                nix = [ "nixfmt" ];
                c = [ "clang-format" ];
                go = [ "gofmt" ];
              };
            notify_on_error = true;
            log_level = "info";
          };
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
              {
                name = "nvim_lsp";
                priority = 6;
              }
              {
                name = "emoji";
                priority = 5;
              }
              {
                name = "buffer"; # text within current buffer
                option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
                keywordLength = 3;
                priority = 10;
              }
              {
                name = "copilot";
                priority = 2;
              }
              {
                name = "path"; # file system paths
                keywordLength = 3;
                priority = 9;
              }
              {
                name = "luasnip"; # snippets
                keywordLength = 3;
                priority = 9;
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
        lspkind = {
          enable = true;
          symbolMap = {
            Copilot = "";
            Text = "󰉿";
          };
        };
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        cmp-path.enable = true;
        cmp_luasnip.enable = true;
        cmp-emoji.enable = true;
        copilot-cmp = {
          enable = true;
          fixPairs = true;
        };
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
          folding = true;
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
          updateFocusedFile.enable = true;
          diagnostics = {
            enable = true;
            showOnDirs = true;
          };
        };
        chatgpt = {
          enable = true;
          settings = {
            api_key_cmd = "cat /run/secrets/api/chatgpt";
            openai_params = {
              model = "chatgpt-4o-latest";
              temperature = 0.7;
              top_p = 0.8;
              presence_penalty = 0.5;
              frequency_penalty = 0.5;
              max_tokens = 2048;
            };
            openai_edit_params = {
              model = "chatgpt-4o-latest";
            };
          };
        };
        markdown-preview = {
          enable = true;
          settings = {
            auto_close = 1;
          };
        };
        web-devicons.enable = true;
        notify.enable = true;
        comment.enable = true;
        tmux-navigator.enable = true;
      };
    };
  };
}
