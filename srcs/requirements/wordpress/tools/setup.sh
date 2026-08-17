#!/bin/sh

# 1. Check if WordPress configuration exists
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    # echo "Waiting for MariaDB to be ready..."
    # while ! mariadb-admin ping -h"mariadb" -u"root" -p"mq71sg" --silent; do
    #     sleep 2
    # done

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

	echo "php_admin_value[error_log] = /proc/1/fd/2" >> /etc/php83/php-fpm.d/www.conf
	echo "access.log = /proc/1/fd/1" >> /etc/php83/php-fpm.d/www.conf
        
    echo "WordPress successfully installed!"
else
    echo "WordPress is already installed. Skipping initialization."
fi

chown -R www-data:www-data /var/www/html
# 4. Hand off execution back to the main container process (PHP-FPM)
# No quotes around the command and its arguments!
#

exec php-fpm83 -F
# exec nc -l 0.0.0.0  9000 
