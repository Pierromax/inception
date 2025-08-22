FROM debian:trixie

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server netcat

COPY ./tools/init_db.sh /init_db.sh

RUN chmod +x /init_db.sh

ENTRYPOINT ["/init_db.sh"]