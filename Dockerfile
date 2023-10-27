FROM debian:bullseye-slim

WORKDIR /host

EXPOSE 3000 5173 8080

# This is sometimes needed for distros, else NerdFont glyphs may not appear correctly
ENV LANG en_us.utf-8

ARG USER_ID
ARG GID

RUN groupadd -g ${GID} kenesu && \
  useradd -m -u ${USER_ID} -g ${GID} -s /bin/bash kenesu

COPY packages.nix /root/packages.nix
ENV PATH="/root/.nix-profile/bin:${PATH}"
ENV PATH="/nix/var/nix/profiles/default/bin:${PATH}"

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
