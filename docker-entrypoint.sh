#!/bin/sh
set -e
mkdir -p /var/log/cron
ln -sf /proc/1/fd/1 /var/log/cron/cron.log
[ -n "$BACKUPSETS" ] && sed -i "s|^backupsets =.*|backupsets = $BACKUPSETS|" /etc/holland/holland.conf
[ -n "$SCHEDULE" ] && sed -ri "s/^([^ ]+ [^ ]+ [^ ]+ [^ ]+ [^ ]+)/${SCHEDULE}/" /var/spool/cron/crontabs/root
[ -n "$TZ" ] && [ -f /usr/share/zoneinfo/"$TZ" ] && { cp /usr/share/zoneinfo/"$TZ" /etc/localtime; echo "$TZ" > /etc/timezone; }
exec "$@"
