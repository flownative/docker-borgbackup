#!/bin/bash

SSH_DIR=$(dirname ~/.ssh/x)

shopt -s nocasematch

BORGBACKUP_SUDO=${BORGBACKUP_SUDO:-no}
BORGBACKUP_CACHE_DIR=${BORGBACKUP_CACHE_DIR:-~/.cache/borg}
BORGBACKUP_SECURITY_DIR=${BORGBACKUP_SECURITY_DIR:-~/.config/borg/security}

mounts=""
variables=""
sudo=""
if [[ "$BORGBACKUP_SUDO" == 1 || "$BORGBACKUP_SUDO" =~ ^(yes|true)$ ]]; then
    sudo="sudo"
fi

$sudo mkdir -p "${BORGBACKUP_CACHE_DIR}" "${BORGBACKUP_SECURITY_DIR}" "${SSH_DIR}"
$sudo touch "${SSH_DIR}/known_hosts"

mounts="${mounts} --mount type=bind,src=${BORGBACKUP_CACHE_DIR},target=/root/.cache/borg"
mounts="${mounts} --mount type=bind,src=${BORGBACKUP_SECURITY_DIR},target=/root/.config/borg/security"
mounts="${mounts} --mount type=bind,src=${SSH_DIR}/known_hosts,target=/root/.ssh/known_hosts"

if [[ -n $SSH_AUTH_SOCK ]]; then
    mounts="${mounts} --mount type=bind,src=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock"
    variables="${variables} -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock"
fi

# shellcheck disable=SC2086
$sudo docker run -ti \
    --name borgbackup \
    --rm \
    --privileged \
    $mounts \
    $variables \
    flownative/borgbackup "$@"
