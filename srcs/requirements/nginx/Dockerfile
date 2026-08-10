FROM	alpine:3.24.1

RUN	apk update & apk add nginx ca-certificates openssl

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/server.key \
	-out /etc/nginx/server.crt \
	-subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

COPY	conf	/etc/nginx/nginx.conf
# COPY	index.html	/var/www/index.html

CMD ["nginx", "-g", "daemon off;"]
