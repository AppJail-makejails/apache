#!/bin/sh

set -e

ENVVARS="/usr/local/sbin/envvars"

if [ -f "${ENVVARS}" ]; then
    . "${ENVVARS}"
fi

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/httpd.pid

exec httpd -DFOREGROUND "$@"
