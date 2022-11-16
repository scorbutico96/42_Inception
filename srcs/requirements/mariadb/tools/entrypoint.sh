#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
	
	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	tempfile=`mktemp`
	if [ ! -f "$tempfile" ]; then
		return 1
	fi

	cat << EOF > $tempfile
USE mysql;

DROP DATABASE IF EXISTS test ;
DELETE FROM	mysql.user WHERE User='';

FLUSH PRIVILEGES ;

SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION ;

FLUSH PRIVILEGES ;

CREATE DATABASE ${WP_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci ;
CREATE USER '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWORD}' ;
GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%' ;

FLUSH PRIVILEGES ;

CREATE USER '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'localhost' ;
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_USER}'@'%' ;

FLUSH PRIVILEGES ;
EOF

	/usr/bin/mysqld --user=mysql --bootstrap < $tempfile
	rm -f $tempfile
fi

exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@