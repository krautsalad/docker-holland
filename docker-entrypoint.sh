#!/bin/sh
set -e
mkdir -p /var/log/cron
ln -sf /proc/1/fd/1 /var/log/cron/cron.log
[ -n "$BACKUPSETS" ] && sed -i "s|^backupsets =.*|backupsets = $BACKUPSETS|" /etc/holland/holland.conf
exec "$@"
