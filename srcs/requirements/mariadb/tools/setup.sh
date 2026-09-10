#!/bin/sh

set -e

# some required paths for mariaDB to works
mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql;

# the user which is mariaDB, the ownership of that directory so the DB works fine
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MySQL data directory not found. Initializing database..."

    DB_PWD=$(cat /run/secrets/db_password.txt)
    DB_ROOT_PWD=$(cat /run/secrets/db_root_password.txt)

    # Initialize the system DB
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mariadbd --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO '$DB_ROOT_USER'@'%' IDENTIFIED BY '${DB_ROOT_PWD}' WITH GRANT OPTION;
GRANT ALL ON *.* TO '$DB_ROOT_USER'@'$HOSTNAME' IDENTIFIED BY '${DB_ROOT_PWD}' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '${DB_PWD}';
GRANT ALL ON \`$DB_NAME\`.* TO '$DB_USER'@'%';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES;
EOF
    echo "Database initialized."
fi

# Start MariaDB server, listening on all interfaces (skip-name-resolve speeds up internal lookups)
echo "Starting MariaDB Server..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking=0 --bind-address=0.0.0.0
