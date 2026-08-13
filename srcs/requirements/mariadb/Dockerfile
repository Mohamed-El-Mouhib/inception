FROM	alpine:3.24.1

RUN	apk update & apk add mariadb mariadb-client

RUN mkdir -p /run/mysqld /var/lib/mysql \
	&& chown -R mysql:mysql /run/mysqld /var/lib/mysql

RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

COPY ./tools/setup.sh /usr/local/bin/setup.sh
RUN chmod +x /usr/local/bin/setup.sh

ENTRYPOINT ["/usr/local/bin/setup.sh"]
