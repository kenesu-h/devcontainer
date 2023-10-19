FROM debian:bullseye-slim

WORKDIR /host

EXPOSE 3000 5173 8080

# This is sometimes needed for distros, else NerdFont glyphs may not appear correctly
ENV LANG en_us.utf-8

COPY packages.nix /root/packages.nix
ENV PATH="/root/.nix-profile/bin:${PATH}"

COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]
