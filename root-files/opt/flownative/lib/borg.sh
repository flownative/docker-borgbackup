#!/bin/bash
# shellcheck disable=SC1090

# =======================================================================================
# LIBRARY: BORG
# =======================================================================================

# ---------------------------------------------------------------------------------------
# borg_get_borg() - Returns source code of a borg script which runs this Docker container
#
# @return void
#
borg_get_borg() {

        cat <<- 'EOM'
#!/bin/bash

SSH_DIR=$(dirname ~/.ssh/x)

docker run -ti \
    --name borgbackup \
    --rm \
    -v "${SSH_DIR}":/root/.ssh \
    flownative/borgbackup:dev "$@"
EOM
}

