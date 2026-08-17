FROM	alpine:3.24.1

RUN apk add --no-cache \
	curl \
	php83 \
	php83-fpm \
	php83-mysqli \
	php83-json \
	php83-openssl \
	php83-curl \
	php83-zlib \
	php83-xml \
	php83-phar \
	php83-intl \
	php83-dom \
	php83-xmlreader \
	php83-ctype \
	php83-session \
	php83-mbstring \
	php83-gd \
	php83-opcache \
	php83-zip \
	php83-iconv \
	mariadb-client

WORKDIR	/var/www/html

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 0.0.0.0:9000/g' /etc/php83/php-fpm.d/www.conf

# RUN ln -sf /dev/stdout /var/log/php8.3-fpm.log

RUN	curl -o wordpress.tar.gz  https://wordpress.org/latest.tar.gz && \
	tar -xzf wordpress.tar.gz --strip-components=1 && \
	rm wordpress.tar.gz

RUN	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /bin/wp

RUN	ln -s /usr/bin/php83 /usr/bin/php

COPY	--chmod=755 ./tools/setup.sh /usr/local/bin/setup.sh

ENTRYPOINT	["/usr/local/bin/setup.sh"]
