#!/bin/sh

DB_PWD=$(cat /run/secrets/db_password.txt)

# Check if mariadb is running before wordpress so we can run create/access the site
# ENV instead of hardcoded crendetials
echo "Waiting for MariaDB to be ready..."
while ! mariadb-admin ping -h"$MARIADB" -u"$DB_USER" -p"${DB_PWD}" --silent; do
	sleep 2
done

# check if wordpress configuration exists
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    echo "Downloading WordPress..."
    wp core download --allow-root --force
    echo "Creating wp-config.php..."

    # create the configuration file linking to mariadb
    wp config create \
	    --dbname="$DB_NAME" \
	    --dbuser="$DB_USER" \
	    --dbpass="${DB_PWD}"\
	    --dbhost="$MARIADB" \
	    --allow-root

    echo "Installing WordPress..."

    # execute the automated install
    wp core install \
	    --url="$HOSTNAME" \
	    --title="$WP_TITLE" \
	    --admin_user="$WP_ADMIN_USER" \
	    --admin_password="$WP_ADMIN_PWD" \
	    --admin_email="$WP_ADMIN_MAIL" \
	    --skip-email \
	    --allow-root

    # create a standard user 
    wp user create \
	    "$WP_USER" "$WP_USER_MAIL" \
	    --role="$WP_USER_ROLE"     \
	    --user_pass="$WP_USER_PWD" \
	    --allow-root
 
    echo "WordPress successfully installed!"
else
	if ! wp core is-installed --allow-root 2> /dev/null; then
		echo "Config exists but database is empty. Running installation..."
		wp core install \
			--url="$HOSTNAME" \
			--title="$WP_TITLE" \
			--admin_user="$WP_ADMIN_USER" \
			--admin_password="$WP_ADMIN_PWD" \
			--admin_email="$WP_ADMIN_MAIL" \
			--skip-email \
			--allow-root
	else
		echo "WordPress is already installed. Skipping initialization."
	fi
fi

exec php-fpm83 -F
