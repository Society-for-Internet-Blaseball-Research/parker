#!/usr/bin/env bash

set -euo pipefail
echo "Setting management realm password for ${1:-$USER}."
sudo /usr/bin/htpasswd -B /srv/docker/management/traefik_data/mgmt.htpasswd "${1:-$USER}"
docker restart management-auth-file-trigger-1
