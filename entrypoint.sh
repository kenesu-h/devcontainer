#!/bin/bash

BOOTSTRAPPED="/home/kenesu/bootstrapped"

if [ ! -f "$BOOTSTRAPPED" ]; then
  apt-get update
  apt-get install -y curl xz-utils xsel

  curl -L https://nixos.org/nix/install | bash -s -- --daemon
  nix-env -f /root/packages.nix -iA tools

  mkdir -p /home/kenesu/.ssh
  touch /home/kenesu/.ssh/known_hosts
  ssh-keyscan github.com >> /home/kenesu/.ssh/known_hosts

  su kenesu -c "yadm clone --no-bootstrap git@github.com:kenesu-h/dotfiles.git && \
    git clone --depth=1 https://github.com/mattmc3/antidote.git /home/kenesu/.antidote && \
    git clone https://github.com/tmux-plugins/tpm /home/kenesu/.tmux/plugins/tpm && \
    /home/kenesu/.tmux/plugins/tpm/bin/install_plugins"

  su kenesu -c "PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash' &&\
    curl https://pyenv.run | bash"

  npm install -g ts-node typescript '@types/node'

  touch "$BOOTSTRAPPED"
fi

echo "Entrypoint script complete"

exec tail -f /dev/null
