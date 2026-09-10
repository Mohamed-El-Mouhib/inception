#!/bin/sh

set -e

# some required paths for mariaDB to works
mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql;

# the user which is mariaDB, the ownership of that directory so the DB works fine
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MySQL data directory not found. Initializing database..."

    DB_ROOT_USER=$(cat /run/secrets/db_root_user)
    DB_ROOT_PWD=$(cat /run/secrets/db_root_pwd)
    WP_ADMIN_USER=$(cat /run/secrets/wp_admin_login)
    WP_ADMIN_PWD=$(cat /run/secrets/wp_admin_pwd)

    # Initialize the system DB
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mariadbd --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO '${DB_ROOT_USER}'@'%' IDENTIFIED BY '${DB_ROOT_PWD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO '${DB_ROOT_USER}'@'$HOSTNAME' IDENTIFIED BY '${DB_ROOT_PWD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '${WP_ADMIN_USER}'@'%' IDENTIFIED BY '${WP_ADMIN_PWD}';
GRANT ALL ON \`$DB_NAME\`.* TO '${WP_ADMIN_USER}'@'%';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES;
EOF
    echo "Database initialized."
fi

# Start MariaDB server, listening on all interfaces (skip-name-resolve speeds up internal lookups)
echo "Starting MariaDB Server..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking=0 --bind-address=0.0.0.0
