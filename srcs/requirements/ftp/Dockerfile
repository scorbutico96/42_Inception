FROM alpine:3.14.4

RUN apk update
RUN apk add --no-cache tzdata \
	vsftpd

COPY tools /
COPY conf/vsftpd.conf /etc/vsftpd

ENTRYPOINT ["sh", "entrypoint.sh"]