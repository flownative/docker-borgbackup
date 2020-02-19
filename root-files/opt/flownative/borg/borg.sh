#!/bin/bash

SSH_DIR=$(dirname ~/.ssh/x)

docker run -ti \
    --name borgbackup \
    --rm \
    -v "${SSH_DIR}":/root/.ssh \
    flownative/borgbackup:dev "$@"
