#!/usr/bin/env bash

#
# {{ ansible_managed }}
#

printf "[$(apt-mark showmanual | sed -e 's/.*/"\0"/' | paste -sd,)]\n"
