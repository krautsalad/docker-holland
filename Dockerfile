FROM alpine

RUN apk update && \
    apk add --no-cache busybox-suid mongodb-tools mysql-client postgresql-client python3 py3-mongo py3-pip tzdata && \
    apk add --no-cache --virtual .build-deps build-base git postgresql-dev python3-dev && \
    git clone https://github.com/holland-backup/holland.git /holland && \
    cd /holland && \
    git submodule update --init --recursive && \
    python3 setup.py install && \
    cd plugins/holland.lib.common && python3 setup.py install && \
    cd ../holland.lib.mysql && python3 setup.py install && \
    cd ../holland.backup.mongodump && python3 setup.py install && \
    cd ../holland.backup.mysqldump && python3 setup.py install && \
    cd ../holland.backup.pgdump && python3 setup.py install && \
    apk del .build-deps && \
    rm -rf /etc/holland /holland /root/.cache /tmp/* /usr/lib/python*/ensurepip /var/cache/apk/* /var/tmp/*

RUN rm -rf /var/spool/cron/crontabs && \
    mkdir -p /var/spool/cron/crontabs && \
    cat <<EOF > /var/spool/cron/crontabs/root
0 0 * * * /usr/bin/holland backup >> /var/log/cron/cron.log 2>&1
EOF

ENV PATH=$PATH:/usr/libexec/postgresql
RUN echo 'export "PATH=$PATH:/usr/libexec/postgresql"' >> /etc/profile

COPY holland /etc/holland
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["crond", "-f"]
