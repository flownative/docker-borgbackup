#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load lib
. "${FLOWNATIVE_LIB_PATH}/borg.sh"

if [[ "$*" = *"shell"* ]]; then
    bash
    exit 0
fi

if [[ "$*" = *"get-borg"* ]]; then
    borg_get_borg
    exit 0
fi

exec "${BORG_BASE_PATH}/bin/borg" "$@"
