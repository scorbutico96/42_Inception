FROM alpine:3.14.4

RUN apk update
RUN apk add --no-cache tzdata \
	nginx openssl

COPY tools /
COPY conf/nginx.conf /etc/nginx

ENTRYPOINT ["sh", "entrypoint.sh"]