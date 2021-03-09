#!/usr/bin/env bash
hostname mysql-02-prod

sed -i 's/server-id=1/server-id=2/g' /etc/my.cnf
rm -f /var/lib/mysql/mysql5/auto.cnf

mysql < /vagrant/devel/employees_db_dump.sql
mysql < /vagrant/devel/employees_create_users.sql

systemctl restart mysqld
