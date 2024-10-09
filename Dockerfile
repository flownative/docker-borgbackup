FROM bitnami/minideb:bookworm

LABEL org.opencontainers.image.authors="Robert Lemke <robert@flownative.com>"

LABEL org.label-schema.name="Borg Backup"
LABEL org.label-schema.description="Docker image providing the Borg backup client"
LABEL org.label-schema.vendor="Flownative GmbH"

# -----------------------------------------------------------------------------
# Borg
# Latest versions: https://packages.debian.org/bullseye/borgbackup

ENV FLOWNATIVE_LIB_PATH=/opt/flownative/lib \
    FLOWNATIVE_LOG_PATH="/opt/flownative/log" \
    FLOWNATIVE_LOG_PATH_AND_FILENAME="/dev/stdout" \
    BORG_BASE_PATH=/opt/flownative/borg \
    PATH="/opt/flownative/borg/bin:$PATH" \
    LOG_DEBUG=true

ENV FLOWNATIVE_LOG_PATH_AND_FILENAME=/dev/stdout

COPY --from=europe-docker.pkg.dev/flownative/docker/bash-library:1 /lib $FLOWNATIVE_LIB_PATH

COPY root-files /
RUN /build.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--help" ]
