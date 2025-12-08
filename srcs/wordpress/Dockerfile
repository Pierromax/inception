FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV WP_PATH=/var/www/wordpress

RUN apt update && apt upgrade -y && apt install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-xml \
    php8.2-mbstring \
    php8.2-zip \
    curl \
    netcat-openbsd \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp
    
COPY tools/init_wp.sh /usr/local/bin/init_wp.sh
RUN chmod +x /usr/local/bin/init_wp.sh

WORKDIR ${WP_PATH}

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/init_wp.sh"]