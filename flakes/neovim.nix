{ pkgs, inputs, ... }:

let
  easy-action = pkgs.vimUtils.buildVimPlugin {
    pname = "easy-action";
    version = "git";
    src = inputs.easy-action;
  };

  tree-sitter-manager = pkgs.vimUtils.buildVimPlugin {
    pname = "tree-sitter-manager";
    version = "git";
    src = inputs.tree-sitter-manager;
  };
in
{
  programs.nixvim = {
    enable = true;

    nixpkgs.source = inputs.nixpkgs;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true; # vim.loader.enable()

    opts = {
      encoding = "utf-8";
      shell = "zsh";
      title = true;
      number = true;
      fileformat = "unix";
      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      ignorecase = true;
      smartcase = true;
      wildmenu = true;
      background = "dark";
      completeopt = [ "menuone" "noinsert" ];
    };

    highlight = {
      Normal = { bg = "none"; ctermbg = "none"; };
      NonText = { bg = "none"; ctermbg = "none"; };
      NormalNC = { bg = "none"; };
      NormalSB = { bg = "none"; };
    };

    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      bufferline.enable = true;
      neo-tree = {
        enable = true;
        settings = {
          filesystem = {
            filtered_items = {
              visible = false;
              hide_dotfiles = false;
              hide_gitignored = true;
              hide_hidden = true;
            };
            window.width = 30;
          };
        };
      };
      hop.enable = true;
    };

    extraPlugins = [
      pkgs.vimPlugins.mason-nvim
      pkgs.vimPlugins.promise-async
      easy-action
      tree-sitter-manager
    ];

    extraConfigLua = ''
      vim.scriptencoding = 'utf-8'

      require("mason").setup()

      require("easy-action").setup({})

      require("tree-sitter-manager").setup({
        auto_install = true,
      })
    '';

    keymaps = [
      { mode = "n"; key = "<leader>e"; action = "<cmd>BasicEasyAction<cr>"; options = { silent = true; desc = "easy-action"; }; }
      { mode = "n"; key = "<leader>n"; action = "<cmd>Neotree toggle<cr>"; options = { silent = true; desc = "Toggle neo-tree"; }; }
      { mode = "n"; key = "<S-l>"; action = "<cmd>BufferLineCycleNext<cr>"; options = { silent = true; desc = "Next buffer"; }; }
      { mode = "n"; key = "<S-h>"; action = "<cmd>BufferLineCyclePrev<cr>"; options = { silent = true; desc = "Prev buffer"; }; }
    ];

    extraPackages = with pkgs; [
      tree-sitter
      gcc
      unzip
    ];
  };

  environment.systemPackages = with pkgs; [
    lua-language-server
    nil
    ripgrep
    fd
  ];
}
