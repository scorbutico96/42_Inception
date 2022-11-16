#!/bin/sh

while ! mariadb -h$WP_DB_HOST -u$MYSQL_USER -p$MYSQL_PASSWORD &>/dev/null; do
	echo "Waiting for database"
	sleep 1
done

if [[ ! -f index.php ]]
then
	wp core download --allow-root
	wp config create --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASSWORD --dbhost=$WP_DB_HOST --locale=en_DB --allow-root
	wp core install --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL --allow-root
fi

exec php-fpm7 -FR