FROM debian:bookworm

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=MO/ST=KH/O=42/OU=42/CN=ple-guya.fr"

COPY ./tools/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/nginx/nginx.conf

RUN mkdir -p /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

CMD ["nginx", "-g", "daemon off;"]