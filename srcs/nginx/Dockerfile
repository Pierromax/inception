FROM debian:bookworm

RUN apt update && apt upgrade -y \
    && apt install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/* \

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -newkey rsa:2048 \
        -out /etc/nginx/ssl/inception.crt \
        -keyout /etc/nginx/ssl/inception.key \
        -subj "/C=MO/ST=KH/O=42/OU=42/CN=ple-guya.fr"

COPY ./tools/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]