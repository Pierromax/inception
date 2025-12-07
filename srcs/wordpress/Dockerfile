FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV WP_PATH=/var/www/html

RUN apt update && apt upgrade -y && apt install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-xml \
    php8.2-mbstring \
    php8.2-zip \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY conf/php.ini /etc/php/8.2/fpm/php.ini

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR ${WP_PATH}

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]