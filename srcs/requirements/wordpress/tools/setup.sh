#!/bin/sh

# Check if mariadb is running before wordpress so we can run create/access the site
echo "Waiting for MariaDB to be ready..."
while ! mariadb-admin ping -h"mariadb" -u"root" -p"mq71sg" --silent; do
	sleep 2
done

# check if wordpress configuration exists
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    echo "Downloading WordPress..."
    wp core download --allow-root --force
    echo "Creating wp-config.php..."

    # create the configuration file linking to mariadb
    wp config create \
	    --dbname="wp_db" \
	    --dbuser="root" \
	    --dbpass="mq71sg" \
	    --dbhost="mariadb" \
	    --allow-root

    echo "Installing WordPress..."

    # execute the automated install
    wp core install \
	    --url="localhost" \
	    --title="inception" \
	    --admin_user="wp_drake" \
	    --admin_password="wp_pass" \
	    --admin_email="wp_drake@example.com" \
	    --skip-email \
	    --allow-root

    # create a standard user 
    wp user create \
	    user_ user_@42.fr \
	    --role=author \
	    --user_pass=randomPass \
	    --allow-root
 
    echo "WordPress successfully installed!"
else
	if ! wp core is-installed --allow-root 2> /dev/null; then
		echo "Config exists but database is empty. Running installation..."
		wp core install \
			--url="localhost" \
			--title="inception" \
			--admin_user="wp_drake" \
			--admin_password="wp_pass" \
			--admin_email="wp_drake@example.com" \
			--skip-email \
			--allow-root
	else
		echo "WordPress is already installed. Skipping initialization."
	fi
fi

exec php-fpm83 -F
