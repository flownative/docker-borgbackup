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
        cat "${BORG_BASE_PATH}/scripts/borg.sh" > /borg-test.sh
        cat "${BORG_BASE_PATH}/scripts/borg.sh"
}
