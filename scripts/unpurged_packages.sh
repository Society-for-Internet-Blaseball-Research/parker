#!/usr/bin/env bash

dpkg --get-selections | awk '$2 == "deinstall" { print $1 }'
