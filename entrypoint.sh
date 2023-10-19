#!/bin/bash

BOOTSTRAPPED="/root/bootstrapped"

if [ ! -f "$BOOTSTRAPPED" ]; then
  # You will have to change this to accommodate your parent image's package manager and repos
  apt-get update && \
  apt-get install -y curl xz-utils

  curl -L https://nixos.org/nix/install | bash -s -- --daemon
  nix-env -f /root/packages.nix -iA tools

  mkdir -p /root/.ssh
  touch /root/.ssh/known_hosts
  ssh-keyscan github.com >> /root/.ssh/known_hosts

  yadm clone --no-bootstrap git@github.com:kenesu-h/dotfiles.git 
  git clone --depth=1 https://github.com/mattmc3/antidote.git /root/.antidote
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && \
    /root/.tmux/plugins/tpm/bin/install_plugins

  PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash'
  curl https://pyenv.run | bash

  npm install -g ts-node typescript '@types/node'

  touch "$BOOTSTRAPPED"
fi

echo "Entrypoint script complete"

exec tail -f /dev/null
