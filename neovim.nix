{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    configure = {
      # プラグイン (packpathのstartに入り、起動時に自動ロードされる)
      packages.plugins.start = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        telescope-nvim
        plenary-nvim
      ];

      # init.vim相当。Luaはlua heredocで書く
      customRC = ''
        lua << EOF
        vim.g.mapleader = " "

        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.expandtab = true
        vim.opt.shiftwidth = 2
        vim.opt.tabstop = 2
        vim.opt.clipboard = "unnamedplus"
        EOF
      '';
    };
  };

  # nvimから使う外部コマンド (LSP、検索ツールなど)
  environment.systemPackages = with pkgs; [
    lua-language-server
    nil
    ripgrep
    fd
  ];
}
