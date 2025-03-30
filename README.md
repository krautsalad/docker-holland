# docker-holland

Cron-Managed Holland Database Backup.

**docker-holland** is an Alpine-based Docker container that periodically runs the [Holland backup program](https://hollandbackup.org/) using cron. It provides an easy way to automate database backups with Holland and is preconfigured for both `mysqldump` and `pgdump`.

## Configuration

### Docker Compose Example

```yml
# docker-compose.yml
services:
  holland:
    container_name: holland
    environment:
      BACKUPSETS: >-
        server1.example.com,
        server2.example.com
      SCHEDULE: 0 3 * * *
      TZ: Europe/Berlin
    image: krautsalad/holland
    restart: unless-stopped
    volumes:
      - ./config:/etc/holland/backupsets:ro
      - ./data:/var/lib/holland
```

### Environment Variables

- `BACKUPSETS`: Comma-separated list of backupset names for Holland to manage (default: empty).
- `SCHEDULE`: Cron schedule for running the backup (default: `0 0 * * *`).
- `TZ`: Timezone setting (default: `UTC`).

## How it works

At runtime, the container's cron job executes `holland backup`, creating a backup for each of the defined backupsets.

Holland will be able to resolve all database container names on the same Docker network. It is recommended to create a custom Docker network (e.g., `docker network create holland`) and then attach all desired containers—including the holland container—to that network:

```yml
# docker-compose.yml
networks:
  holland:
    external: true

services:
  holland:
    networks:
      - holland
```

### Backupsets Configuration

Place your individual backupset configuration files in the `./config` directory. All files must have the `.conf` extension.

For example, for a MySQL database, you might have a file named `server1.example.com.conf`:

```txt
# server1.example.com.conf
[holland:backup]
auto-purge-failures = yes
backups-to-keep = 7
estimated-size-factor = 0.6
purge-policy = after-backup
plugin = mysqldump
relative-symlinks = yes

[mysql:client]
host = server1.example.com-db
password = VerySecurePassword
port = 3306
user = root
```

And for a PostgreSQL database, a file named `server2.example.com.conf` could look like this:

```txt
[holland:backup]
auto-purge-failures = yes
backups-to-keep = 7
estimated-size-factor = 0.6
purge-policy = after-backup
plugin = pgdump
relative-symlinks = yes

[pgauth]
hostname = server2.example.com-db
password = VerySecurePassword
port = 5432
username = postgres
```

## Source Code

You can find the full source code on [GitHub](https://github.com/krautsalad/docker-holland).
