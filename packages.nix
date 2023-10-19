let
  pinnedNixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/refs/tags/23.05.tar.gz";
  }) {};

in
with pinnedNixpkgs;

{
  tools = buildEnv {
    name = "tools";
    paths = [
      act
      gcc
      git
      go
      less
      neovim
      nodejs_20
      openssh
      ps
      ripgrep
      tmux
      yadm
      zsh
    ];
  };
}
