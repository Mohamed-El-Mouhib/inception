FROM	alpine:3.24.1

RUN	apk update && apk add --no-cache mariadb mariadb-client

COPY	./tools/setup.sh /usr/local/bin/setup.sh

RUN	chmod +x /usr/local/bin/setup.sh

ENTRYPOINT	["/usr/local/bin/setup.sh"]
