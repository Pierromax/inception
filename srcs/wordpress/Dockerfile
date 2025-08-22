FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y curl php php7.4-fpm php-mysql mariadb-client

COPY ./tools/init_wp.sh /init_wp.sh

RUN chmod +x /init_wp.sh

ENTRYPOINT ["/init_wp.sh"]