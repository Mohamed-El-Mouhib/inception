FROM	alpine:3.24.1

RUN	apk update && apk add --no-cache nginx ca-certificates openssl

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/server.key \
	-out /etc/nginx/server.crt \
	-subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

COPY	conf	/etc/nginx/http.d/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]
