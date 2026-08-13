#!/bin/sh

# some required paths for mariaDB to works
mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

# making sure that if the /var/lib/mysql/mysql doesn't exist it re initiate DB tables and grants
# the user which is mariaDB, the ownership of that directory so the DB works fine
if [ ! -d "/var/lib/mysql/mysql" ]; then

    echo "[info] MySQL data directory not found. Initializing database..."
    chown -R mysql:mysql /var/lib/mysql
    # Initialize the system DB
    sudo mariadb-install-db --user=mysql --datadir=/var/lib/mysql --rpm
    echo "[info] Database initialized."

fi

# Ensure correct permissions on every startup
chown -R mysql:mysql /var/lib/mysql

# Start MariaDB server, listening on all interfaces (skip-name-resolve speeds up internal lookups)
echo "[info] Starting MariaDB Server..."
exec mariadbd --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --skip-name-resolve
