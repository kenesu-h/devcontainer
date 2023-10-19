# devcontainer

A base Docker image for containerizing my command line tools and dotfiles.

Sometimes, projects will opt to isolate development environments in containers. This usually has
decent integration with editors like JetBrains editors or VSCode, but not so much for Vim - and by
extension, Neovim. This is a problem since Neovim's LSPs rely on being in the same environment,
which means you have to either:

- Install the necessary tooling and dependencies to replicate the environment in the host, which
  defeats the purpose of containers and can be a headache to manage.
- Install Vim and related tooling in the container, which must be done every time the container is
  built, but that's something that may not happen very often.

This opts for the latter since it maintains the element of isolation, but keep in mind that there
could be other solutions I'm not aware of.

While this image can be used on its own, it's ultimately intended to be used as a base so you have
an idea of how to integrate your tools into existing Docker configurations. In other words, you'll
have to manually edit Dockerfiles, `docker-compose.yml`s, and entrypoint scripts to do so.

The process can generally be broken down like this:

1. Use Docker Compose to mount volumes like project directories and pass in environment variables.
   - You can mount and pass an SSH authorization socket if you'd like the container to share the
     host's SSH key for things like Git operations.
2. Ensure the Dockerfile copies in any files and scripts you'd like the container to use, and calls
   an entrypoint script if needed.
   - In my case, I copied in a Nix script that represents the packages to install with Nix.
3. Ensure your entrypoint script handles any bootstrapping-related steps.
   - Note that, if you passed in an SSH authorization socket, SSH authorization can only happen
     here in the entrypoint step. This happens since Docker only mounts volumes and passes in
     environment variables after running the Dockerfile.
4. Build the container, run it in the background, and open a shell in it after the entrypoint
   script finishes up.

For more information, take a look at the relevant files in the repo.
