#!/bin/sh

if [[ ! -f /etc/nginx/ssl/nginx-selfsigned.key ]]
then
	mkdir -p /etc/nginx/ssl/
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt -subj "/C=IT/ST=Lazio/L=Roma/O=42/OU=42/CN=Inception"
	sed -i 's|DOMAIN_NAME|'${DOMAIN_NAME}'|g' /etc/nginx/nginx.conf
fi

exec nginx -g "daemon off;"