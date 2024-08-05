#!/usr/bin/env bash

set -euo pipefail

if [ "$EUID" -ne 0 ]; then
    >&2 echo "error: this script must be run as root"
    exit
fi

TOP=$(realpath -e -- "$(dirname -- "${BASH_SOURCE[0]}")/..")
REMOTE_HOST=$(cat "$TOP/etc/storage-box.txt")

[[ -f /root/.ssh/restic_ed25519 ]] || ssh-keygen -t ed25519 -f /root/.ssh/restic_ed25519 -N ""
>&2 echo "Copying SSH key -- you may need the storage box password..."
ssh-copy-id -i /root/.ssh/restic_ed25519 -s -p 23 "$REMOTE_HOST"
