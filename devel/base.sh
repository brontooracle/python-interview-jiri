#!/usr/bin/env bash

# disable selinux
setenforce 0
sed -i 's/=enforcing/=permissive/' /etc/sysconfig/selinux
timedatectl set-timezone America/New_York
cp -f /vagrant/devel/hosts /etc/hosts
cp /vagrant/devel/ol7.repo /etc/yum.repos.d/


function setup_mysql_env {
    useradd mysql
    mkdir /var/lib/mysql /var/lib/mysql/mysql5.bin
    chown -R mysql:mysql /var/lib/mysql

    # defaults_extra
    mkdir -p /etc/mysql/defaults_extra_files
    chown root:root /etc/mysql/defaults_extra_files
    chmod 701 /etc/mysql/defaults_extra_files

}

function install_mysql_5_7 {
    cp /vagrant/devel/my.cnf /etc/my.cnf
    yum install -y mysql-community-common mysql-community-devel \
            mysql-community-libs mysql-community-server

    sed -i "s/validate_password/#validate_password/" /etc/my.cnf
    service mysqld start
    sed -i "s/#validate_password/validate_password/" /etc/my.cnf
    service mysqld restart

    # Set username/password to bronto/bronto
    mysql --connect-expired-password -u root -p$(grep "A temporary password is generated for" /var/lib/mysql/mysql5/error.log | awk '{print $NF}') \
        -e 'ALTER USER root@localhost IDENTIFIED WITH mysql_native_password AS "*3BC5C2CF2110D4901733941433601C4FC91260B7"'

    mysql -u root -e 'RENAME USER root@localhost TO bronto@`%`'
    mysql -e "GRANT REPLICATION SLAVE on *.* TO 'bronto'@'%';"
}

setup_mysql_env
install_mysql_5_7
