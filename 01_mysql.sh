#!/bin/bash
set -eo pipefail

chown -R mysql:mysql "$DATADIR"
# first run, database is not initialized
if [ ! -d "$DATADIR/mysql" ]; then

 if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
   MYSQL_ROOT_PASSWORD=mysqlroot
 fi
 if [ -z "$MYSQL_DBNAME" ]; then
   MYSQL_DBNAME=logicaldoc
 fi
 if [ -z "$MYSQL_DBUSER" ]; then
   MYSQL_DBUSER=logicaldoc
 fi
 if [ -z "$MYSQL_DBPASS" ]; then
   MYSQL_DBPASS=logicaldoc
 fi



# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"
 echo "mysql-server-5.6 mysql-server/root_password password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
 echo "mysql-server-5.6 mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD" | sudo debconf-set-selections
 dpkg-reconfigure -f noninteractive  $MYSQL_SERVER

# echo "SQL_STATEMENT" |  mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 mysqld_safe & sleep 10s
 echo "CREATE DATABASE IF NOT EXISTS ${MYSQL_DBNAME};" | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
 echo "GRANT ALL ON ${MYSQL_DBNAME}.* TO '${MYSQL_DBUSER}'@'%' IDENTIFIED BY '${MYSQL_DBPASS}'  WITH GRANT OPTION;" | mysql -u root --password="${MYSQL_ROOT_PASSWORD}"
# printf "Creating Mysql tables for logicaldoc...\n"
# mysql -u $MYSQL_DBUSER --password="${MYSQL_DBPASS}" $MYSQL_DBNAME < /opt/logicaldoc/logicaldoc-core.sql.mysql
# mysql -u $MYSQL_DBUSER --password="${MYSQL_DBPASS}" $MYSQL_DBNAME < /opt/logicaldoc/logicaldoc-dropbox.sql
# echo "COMMIT" | mysql -u $MYSQL_DBUSER --password="${MYSQL_DBPASS}" $MYSQL_DBNAME
 killall mysqld_safe & sleep 3s
fi