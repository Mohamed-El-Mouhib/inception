#!/bin/sh

# "========ENV======="
#
# $HOSTNAME       == localhost
# $MARIADB        == mariadb
# $DB_NAME        == wp_db
# $WP_TITLE       == inception
# $WP_ADMIN_MAIL  == drake@example.com
# $WP_USER        == mel-mouh
# $WP_USER_MAIL   == mel-mouh@42.fr
# $WP_USER_ROLE   == author
#
# "========SECRETS======="
#
# $DB_ROOT_USER   == root
# $DB_ROOT_PWD    == root4ever
# $WP_ADMIN_LOGIN == befdrake
# $WP_ADMIN_PWD   == born2die
# $WP_USER_PWD    == randomPass
#
# "========================="

DB_ROOT_USER=$(cat /run/secrets/db_root_user)
DB_ROOT_PWD=$(cat /run/secrets/db_root_pwd)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_login)
WP_ADMIN_PWD=$(cat /run/secrets/wp_admin_pwd)
WP_USER_PWD=$(cat /run/secrets/wp_admin_pwd)


# Check if mariadb is running before wordpress so we can run create/access the site
# ENV instead of hardcoded crendetials
echo "Waiting for MariaDB to be ready..."
while ! mariadb-admin ping -h"$MARIADB" -u"${DB_ROOT_USER}" -p"${DB_ROOT_PWD}" --silent; do
	sleep 2
done

# check if wordpress configuration exists
if [ ! -f "/var/www/html/wp-config.php" ]; then
    
    echo "Downloading WordPress..."
    wp core download --allow-root --force
    echo "Creating wp-config.php..."

    # create the configuration file linking to mariadb
    wp config create \
	    --dbname="$DB_NAME"        \
	    --dbuser="${WP_ADMIN_USER}" \
	    --dbpass="${WP_ADMIN_PWD}"  \
	    --dbhost="$MARIADB"        \
	    --allow-root

    echo "Installing WordPress..."

    # execute the automated install
    wp core install \
	    --url="$HOSTNAME" \
	    --title="$WP_TITLE" \
	    --admin_user="${WP_ADMIN_USER}" \
	    --admin_password="${WP_ADMIN_PWD}" \
	    --admin_email="$WP_ADMIN_MAIL" \
	    --skip-email \
	    --allow-root

    # create a standard user 
    wp user create \
	    $WP_USER $WP_USER_MAIL \
	    --role=$WP_USER_ROLE \
	    --user_pass=${WP_USER_PWD} \
	    --allow-root
 
    echo "WordPress successfully installed!"
else
	if ! wp core is-installed --allow-root 2> /dev/null; then
		echo "Config exists but database is empty. Running installation..."
		wp core install \
			--url="$HOSTNAME" \
			--title="$WP_TITLE" \
			--admin_user="${WP_ADMIN_USER}" \
			--admin_password="${WP_ADMIN_PWD}" \
			--admin_email="$WP_ADMIN_MAIL" \
			--skip-email \
			--allow-root
	else
		echo "WordPress is already installed. Skipping initialization."
	fi
fi

exec php-fpm83 -F
