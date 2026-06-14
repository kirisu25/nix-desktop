{
  rm = "rm -i";
  cp = "cp -i";

  # Core
  cat = "bat --color=always -p";
  grep = "rg";
  ls = "eza --icons always --classify always --git";
  la = "eza -a --icons always --classify always --all --git";
  ll = "eza --icons always --long --all --git";
  lt = "eza --icons always --classify always --tree";
  lc = "clear && ls";

  # cd
  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";

  # nix
  "flakeupdate" = "nix flake update";

  # git
  gad = "git add";
  gcm = "git commit";
  gpu = "git push";
  gpl = "git pull";
}
