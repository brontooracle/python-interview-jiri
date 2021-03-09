#!/usr/bin/env bash
hostname mysql-03-prod

sed -i 's/server-id=1/server-id=3/g' /etc/my.cnf
rm -f /var/lib/mysql/mysql5/auto.cnf

mysql < /vagrant/devel/sakila_db_dump.sql
mysql < /vagrant/devel/sakila_create_users.sql

systemctl restart mysqld
