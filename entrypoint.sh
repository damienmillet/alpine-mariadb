#!/bin/sh

set -euo pipefail

# set default values
readonly MYSQL_DATABASE="${MYSQL_DATABASE:-}"
readonly MYSQL_USER="${MYSQL_USER:-}"
readonly MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"
readonly MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}"



init_db() {
    service mariadb setup
    service mariadb start
    rc-update add mariadb default

        if [ "$MYSQL_ROOT_PASSWORD" ]; then
          mysql -e "SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;"
        fi
        # create database if requested
        if [ "$MYSQL_DATABASE" ]; then
                mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE ;"
        fi
        # create user if requested
        if [ "$MYSQL_DATABASE" ] && [ "$MYSQL_USER" ] && [ "$MYSQL_PASSWORD" ]; then
                mysql -e "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';"
                mysql -e "FLUSH PRIVILEGES ;"
        fi
  
        for f in /docker-entrypoint-initdb.d/*; do
                [ ! -f "$f" ] && continue
                echo "Starting to import sql file: $f"
                case "$f" in
                        *.sh)  echo "$0: running $f"; . "$f" ;;
                        *.sql) mysql --defaults-file="$MYSQL_ROOT_DEFAULTS_FILE" --database="$MYSQL_DATABASE" < "$f" ;;
                        *.sql.gz) zcat "$f" | mysql --defaults-file="$MYSQL_ROOT_DEFAULTS_FILE" --database="$MYSQL_DATABASE" ;;
                        *) echo "$f: is not a .sql, .sql.gz or a .sh file. Skipping.." ;;
                esac
        done
}

if [ ! -d "/var/lib/mysql/mysql" ]; then
        echo "Initializing database..."
        init_db
        echo "Database initialized"
else
        echo "Database already initialized"
        service mariadb start
fi

while true; do
  sleep 1000
done

