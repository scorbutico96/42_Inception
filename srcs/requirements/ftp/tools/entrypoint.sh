#!/bin/sh

if ! id $FTP_USER &>/dev/null;
then
	echo -e "$FTP_PASSWORD\n$FTP_PASSWORD" | adduser -h /var/ftp -s /sbin/nologin $FTP_USER
fi

touch /etc/vsftpd.chroot_list
chown $FTP_USER:$FTP_USER /var/ftp

exec /usr/sbin/vsftpd -opasv_min_port=21000 -opasv_max_port=21010 /etc/vsftpd/vsftpd.conf