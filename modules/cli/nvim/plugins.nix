{ pkgs, ... }:
let
  normalizedPluginAttr = p: {
    "${builtins.replaceStrings
      [
        "-"
        "."
      ]
      [
        "_"
        "_"
      ]
      (pkgs.lib.toLower p.pname)
    }" =
      p;
  };
  plugins = p: builtins.foldl' (x: y: x // y) { } (map normalizedPluginAttr p);
in
with pkgs.vimPlugins;
plugins [
  cmp-buffer
  cmp-cmdline
  cmp-nvim-lsp
  cmp-path
  cmp_luasnip
  iron-nvim
  lazy-nvim
  lspkind-nvim
  lspsaga-nvim
  lualine-nvim
  luasnip
  neo-tree-nvim
  noice-nvim
  none-ls-nvim
  nui-nvim
  nui-nvim
  nvim-autopairs
  nvim-cmp
  nvim-colorizer-lua
  nvim-lspconfig
  nvim-notify
  nvim-treesitter
  nvim-web-devicons
  plenary-nvim
  remote-nvim-nvim
  telescope-nvim
  toggleterm-nvim
  tokyonight-nvim
  trouble-nvim
  which-key-nvim
]
