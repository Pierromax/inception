service mariadb start
sleep 5

mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"

mariadb -e "CREATE USER IF NOT EXISTS \` ${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \` ${MYSQL_USER}\`@'%';"

mariadb -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p $MYSQL_ROOT_PASSWORD shutdown

mysqldsafe --port=420 --bind-adress=0.0.0.0 --datadir='/var/lib/mysql'
