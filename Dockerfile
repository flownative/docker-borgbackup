FROM flownative/base:buster
MAINTAINER Robert Lemke <robert@flownative.com>

LABEL org.label-schema.name="Borg Backup"
LABEL org.label-schema.description="Docker image providing the Borg backup client"
LABEL org.label-schema.vendor="Flownative GmbH"

# -----------------------------------------------------------------------------
# Borg
# Latest versions: https://packages.debian.org/buster/nginx

ARG BORG_VERSION
ENV BORG_VERSION ${BORG_VERSION}

ENV FLOWNATIVE_LIB_PATH=/opt/flownative/lib \
    BORG_BASE_PATH=/opt/flownative/borg \
    PATH="/opt/flownative/borg/bin:$PATH" \
    LOG_DEBUG=true

COPY --from=docker.pkg.github.com/flownative/bash-library/bash-library:1 /lib $FLOWNATIVE_LIB_PATH

COPY root-files /
RUN /build.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--help" ]
