#!/bin/bash

SSH_DIR=$(dirname ~/.ssh/x)

shopt -s nocasematch

BORG_SUDO=${BORG_SUDO:-no}
BORG_CACHE_DIR=${BORG_CACHE_DIR:-~/.cache/borg}
BORG_REPO=${BORG_REPO:-}
BORG_PASSPHRASE=${BORG_PASSPHRASE:-}
BORG_SECURITY_DIR=${BORG_SECURITY_DIR:-~/.config/borg/security}
BORG_SOURCE_ROOT_DIR=${BORG_SOURCE_ROOT_DIR:-~/}
BORG_SOURCE_MOUNT_DIR=${BORG_SOURCE_MOUNT_DIR:-/source}
BORG_SSH_KEY_FILE=${BORG_SSH_KEY_FILE:-}

mounts=""
sudo=""
if [[ "$BORG_SUDO" == 1 || "$BORG_SUDO" =~ ^(yes|true)$ ]]; then
    sudo="sudo"
fi

$sudo mkdir -p "${BORG_CACHE_DIR}" "${BORG_SECURITY_DIR}" "${SSH_DIR}"
$sudo touch "${SSH_DIR}/known_hosts"

mounts="${mounts} --mount type=bind,src=${BORG_SOURCE_ROOT_DIR},target=${BORG_SOURCE_MOUNT_DIR}"
mounts="${mounts} --mount type=bind,src=${BORG_CACHE_DIR},target=/root/.cache/borg"
mounts="${mounts} --mount type=bind,src=${BORG_SECURITY_DIR},target=/root/.config/borg/security"
mounts="${mounts} --mount type=bind,src=${SSH_DIR}/known_hosts,target=/root/.ssh/known_hosts"

if [[ -n "${BORG_SSH_KEY_FILE}" ]]; then
    filename=$(basename "${BORG_SSH_KEY_FILE}")
    mounts="${mounts} --mount type=bind,src=${BORG_SSH_KEY_FILE},target=/root/.ssh/${filename}"
fi

if [[ -n $SSH_AUTH_SOCK ]]; then
    mounts="${mounts} --mount type=bind,src=/run/host-services/ssh-auth.sock,target=/run/host-services/ssh-auth.sock"
    variables="${variables} -e SSH_AUTH_SOCK=/run/host-services/ssh-auth.sock"
fi

# shellcheck disable=SC2086
set -- \
    --name borg \
    --rm \
    --privileged \
    $mounts \
    $variables \
    -e "BORG_PASSPHRASE=${BORG_PASSPHRASE}" \
    -e "BORG_REPO=${BORG_REPO}" \
    -e "BORG_SOURCE_ROOT_DIR=${BORG_SOURCE_ROOT_DIR}" \
    -e "BORG_SOURCE_MOUNT_DIR=${BORG_SOURCE_MOUNT_DIR}" \
    flownative/borgbackup "$@"

# Check if this script runs in an (interactive) terminal:
case $- in
  *i*) $sudo docker run -ti "$@";;
  *) $sudo docker run "$@";;
esac
