#!/bin/sh

set -e

# some required paths for mariaDB to works
mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql;

# echo "========================="
# echo "ROOT_PWD:" $ROOT_PWD
# echo "ADMIN_PWD:" $ADMIN_PWD
#
# echo "DB_NAME:" $DB_NAME
# echo "ADMIN_LOGIN:" $ADMIN_LOGIN
# echo "========================="

# making sure that if the /var/lib/mysql/mysql doesn't exist it re initiate DB tables and grants
# the user which is mariaDB, the ownership of that directory so the DB works fine
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MySQL data directory not found. Initializing database..."

    # Initialize the system DB
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    mariadbd --user=mysql --bootstrap << EOF
FLUSH PRIVILEGES;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$ROOT_PWD' WITH GRANT OPTION;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '$ROOT_PWD' WITH GRANT OPTION;
CREATE DATABASE IF NOT EXISTS \`$DB_NAME\`;
CREATE USER IF NOT EXISTS '$ADMIN_LOGIN'@'%' IDENTIFIED BY '$ADMIN_PWD';
GRANT ALL ON \`$DB_NAME\`.* TO '$ADMIN_LOGIN'@'%';
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES;
EOF
    echo "Database initialized."
fi

# Start MariaDB server, listening on all interfaces (skip-name-resolve speeds up internal lookups)
echo "Starting MariaDB Server..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking=0 --bind-address=0.0.0.0
