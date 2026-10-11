{ ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    interactiveShellInit = ''
      zstyle ':completion:*' format "%B%d%b"
      zstyle ':completion:*' matcher-list "m:{a-z}={A-Z} r:|[._-]=*"
      zstyle ':completion:*' completer _oldlist _complete _match _history _ignored _approximate _prefix
      zstyle ':completion:*' use-cache yes
      zstyle ':completion:*' verbose yes
      zstyle ':completion:*:default' menu select=2
      zstyle ':completion:*:default' list-colors ""
      fastfetch
    '';
    setOptions = [
      "AUTO_LIST"
      "AUTO_MENU"
      "COMPLETE_IN_WORD"
      "EXTENDED_GLOB"
      "EXTENDED_HISTORY"
      "GLOBDOTS"
      "GLOB_COMPLETE"
      "HIST_EXPAND"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "INC_APPEND_HISTORY"
      "NO_BEEP"
      "NUMERIC_GLOB_SORT"
      "NO_FLOW_CONTROL"
      "SHARE_HISTORY"
    ];
    shellAliases = {
      ls = "exa -la --icons --git";
      sudo = "sudo ";
    };
  };
}
