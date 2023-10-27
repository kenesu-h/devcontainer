# devcontainer

A base Docker image for containerizing my command line tools and dotfiles.

There's plenty of situations where tools, like Neovim's LSPs, rely on being in the same environment
as your project. However, since some projects nowadays isolate these environments in containers, the
only way to accomplish this is to replicate them inside the host - which defeats the purpose - or to
install your tools in the container instead. This opts for the latter and provides a starting point
for those seeking to do the same thing. Note that this will require you to modify your projects'
Dockerfiles and such, so be careful about pushing them, especially if your team probably won't be
okay with it.

## The Gist

1. Mount volumes like your project directories and pass in the necessary environment variables.
2. Use whatever package managers are available in your base image to install all your packages.
3. Use an entrypoint script to bootstrap your environment _only_ when the container is first run.
4. Use `tail -f /dev/null` to keep the container running when spun up.
5. When you're ready, spin up your container in the background and open up your favorite shell.

For an example of how this is done, take a look at the relevant files in the repo.

## Possible Catches

While the gist is conceptually on the simpler side, there are a number of catches involved that may
make the process a bit more complicated. It's worth remembering that this is far from a perfect
solution and should be treated as such.

- If you want your host to share its SSH key with the container, you need to add your key to the SSH
  agent on the host, then mount the SSH authorization socket. This _does_ make git operations on the
  container very convenient once set up but you must add it to the agent for every new session on
  the host, and even then, Mac hosts can't share Unix sockets with a Linux container. However, there
  _is_ a [workaround you can try](https://stackoverflow.com/a/54526131).
- To avoid permission conflicts over mounted volumes, you have to create a new user in the container
  with the same user and group IDs as your host's user. However, you have to be mindful about which
  parts of your entrypoint should be run as root or the new user. In my case, I wanted to apply my
  dotfiles to said new user, so I had to run `yadm clone ...` as them.
