{ config, ... }:
{
  imports = [ ./starship ];
  programs.zsh = {
    enable = true;
    dotDir = "${config.home.homeDirectory}/.config/zsh";
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = import ./alias.nix;

    history.size = 100000;
    history.findNoDups = true;
    history.saveNoDups = true;

    initContent = ''
      # nix
      export NIXPKGS_ALLOW_UNFREE=1

      # zsh-autosuggestions
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#586e75"
      zstyle ':completion:*' list-colors $LSCOLORS

      # load config
      [ -f $ZDOTDIR/.zshrc.local ] && source $ZDOTDIR/.zshrc.local

      # Fuzzy find history
      function fzf-select-history(){
        BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER")
        CURSOR=$#BUFFER
        zle reset-prompt
      }
      zle -N fzf-select-history
      bindkey '^r' fzf-select-history

      # cd to the repository managed by GHQ
      function __ghq-cd() {
        cd $(ghq root)/$(ghq list | fzf)
        zle clear-screen
      }
      zle -N __ghq-cd
      bindkey '^]' __ghq-cd

    '';
  };
}
