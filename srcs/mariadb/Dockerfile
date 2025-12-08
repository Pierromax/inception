FROM debian:bookworm

ENV DEBIAN_FRONTEND=noninteractive

ENV MYSQL_DATA_DIR=/var/lib/mysql 

RUN apt-get update && apt upgrade -y && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${MYSQL_DATA_DIR} /run/mysqld && \
    chown -R mysql:mysql ${MYSQL_DATA_DIR} /run/mysqld

COPY tools/init_db.sh /usr/local/bin/init_db.sh
RUN chmod +x /usr/local/bin/init_db.sh

VOLUME ["/var/lib/mysql"]
EXPOSE 3306

CMD ["init_db.sh"]