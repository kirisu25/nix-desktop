{ pkgs, ... }:
let
  buildInputs = with pkgs; [
    deno
    lazygit
    ripgrep
    nodejs_22
    kdePackages.qtdeclarative
  ];
  lsp = with pkgs; [
    # bash
    bash-language-server
    shellcheck
    shfmt
    #docker
    dockerfile-language-server
    docker-compose-language-service
    # lua
    lua-language-server
    stylua
    # nix
    nil
    nixfmt-rfc-style
    # Python
    pyright
    ruff
    # typescript
    typescript-language-server
  ];
  parsers =
    p: with p; [
      astro
      bash
      c
      css
      dockerfile
      fish
      go
      lua
      make
      markdown
      markdown_inline
      nix
      python
      query
      r
      ruby
      rust
      toml
      tsx
      typescript
      vim
      vimdoc
      yaml
      zig
    ];
  plugins = import ./plugins.nix { inherit pkgs; };

  # A lenient substitution function that mimics the old `substituteAll` behavior
  # by ignoring patterns that are not found in the file.
  lenientSubstitute = file: vars: pkgs.writeText (builtins.baseNameOf file) (
    pkgs.lib.foldl (acc: name:
      let
        value = builtins.getAttr name vars;
        # Coerce derivations to their store path string representation.
        stringValue = if pkgs.lib.isDerivation value then "${value}" else value;
      in pkgs.lib.replaceStrings [ "@${name}@" ] [ stringValue ] acc
    ) (builtins.readFile file) (builtins.attrNames vars)
  );

  configFile = file: {
    "nvim/${file}".source = lenientSubstitute (./. + "/${file}") (
      {
        ts_parser_dirs = pkgs.lib.pipe (pkgs.vimPlugins.nvim-treesitter.withPlugins parsers).dependencies [
          (map toString)
          (builtins.concatStringsSep ",")
        ];
      }
      // plugins
    );
  };
  configFiles = files: builtins.foldl' (x: y: x // y) { } (map configFile files);

in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    defaultEditor = true;
    extraPackages = buildInputs ++ lsp;
  };

  xdg.configFile = configFiles [
    "./init.lua"
    "./lua/plugins/ui.lua"
    "./lua/plugins/misc.lua"
    "./lua/plugins/lsp.lua"
  ];
}
