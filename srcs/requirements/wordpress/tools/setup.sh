#!/bin/sh

# 1. Check if WordPress configuration exists
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    echo "Waiting for MariaDB to be ready..."
    while ! mariadb-admin ping -h"mariadb" -u"root" -p"mq71sg" --silent; do
        sleep 2
    done

    echo "Downloading WordPress..."
    wp core download --allow-root
    echo "Creating wp-config.php..."

    # 2. Create the configuration file linking to MariaDB
    wp config create \
        --dbname="wp_db" \
        --dbuser="root" \
        --dbpass="mq71sg" \
        --dbhost="mariadb" \
        --allow-root

    echo "Installing WordPress..."
    # 3. Execute the automated install
    wp core install \
        --url="localhost" \
        --title="inception" \
        --admin_user="wp_drake" \
        --admin_password="wp_pass" \
        --admin_email="befdrake@inception.com" \
        --skip-email \
        --allow-root

    echo "WordPress successfully installed!"
else
    echo "WordPress is already installed. Skipping initialization."
fi

chown -R www-data:www-data /var/www/html

exec php-fpm83 -F
