#!/bin/sh

source /tmp/check_variables

MARIADB_HOSTNAME=${MARIADB_HOSTNAME:-$MARIADB_PORT_3306_TCP_ADDR}

echo "##########"
echo "wait mysql is started"

until mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_HOSTNAME -e "show databases;" > /dev/null 2>&1
do
  sleep 1
done

echo "mysql has been started"
echo "##########"

mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_HOSTNAME -e "show databases;" | \
  grep "irohaboard" > /dev/null
if [ $? -ne 0 ] ; then
  echo "##########"
  echo "create database 'irohaboard'" 
  echo "##########"

  mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_HOSTNAME mysql <<EOF
CREATE DATABASE irohaboard;
GRANT ALL PRIVILEGES ON irohaboard.* TO 'irohaboard'@'%' IDENTIFIED BY '$IROHABOARD_DB_PASS';
FLUSH PRIVILEGES;
EOF

  echo "##########"
  echo "database 'irohaboard' has been created"
  echo "##########"
else
  echo "##########"
  echo "database 'irohaboard' is already created"
  echo "##########"
fi


echo "##########"
echo "modify database.php"
echo "##########"
sed -i "s/IROHABOARD_DB_PASS/$IROHABOARD_DB_PASS/g" /var/www/html/Config/database.php
sed -i "s/MARIADB_HOSTNAME/$MARIADB_HOSTNAME/g" /var/www/html/Config/database.php

echo "##########"
echo "start apache"
echo "##########"
exec "$@"

