#!/usr/bin/env bash

if [[ $# -lt 2 ]]; then
    >&2 echo "usage: $0 USER KEY_OR_URL"
    exit 0
fi
set -euxo pipefail

args=$(jq --null-input --arg user "$1" --arg key "$2" '{$user, $key}')
ansible localhost --module-name ansible.posix.authorized_key --args "$args"
