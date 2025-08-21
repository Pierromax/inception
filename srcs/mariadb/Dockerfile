FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y mariadb-server netcat

COPY ./mdb-conf.sh /mbd-conf.sh

RUN chmod +x /mbd-conf.sh

ENTRYPOINT ["./init_db.sh"]