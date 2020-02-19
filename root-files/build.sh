#!/bin/bash
# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail

# Load helper libraries

. "${FLOWNATIVE_LIB_PATH}/log.sh"
. "${FLOWNATIVE_LIB_PATH}/packages.sh"


packages_install \
    ca-certificates \
    openssh-client \
    borgbackup

mkdir -p \
    "${BORG_BASE_PATH}/bin" \
    "${BORG_BASE_PATH}/etc" \
    "${BORG_BASE_PATH}/tmp" \
    "${BORG_BASE_PATH}/log"

mv /usr/bin/borg "${BORG_BASE_PATH}/bin/"
ln -s "${BORG_BASE_PATH}/bin/borg" "${BORG_BASE_PATH}/bin/borgbackup"
rm -f /usr/bin/borgbackup

chown -R root:root "${BORG_BASE_PATH}"
chmod -R g+rwX "${BORG_BASE_PATH}"
