yum install -y python36 python36-devel openssl-devel libffi-devel

mysql < /vagrant/devel/interview_tables_dump.sql

sudo -u vagrant pip3 install --user -r /vagrant/requirements.txt
sudo -u vagrant pip3 install --user -e /vagrant/


mysql -h mysql-02-prod -e "SET GLOBAL read_only = 'on';"
read master_file master_pos <<< $(mysql -h mysql-01-prod \
    -e "show master status" --batch --skip-column-names)
mysql -h mysql-02-prod -e "CHANGE MASTER TO MASTER_HOST='mysql-01-prod', \
    MASTER_PORT=3306, MASTER_USER='bronto', MASTER_PASSWORD='bronto', \
    MASTER_LOG_FILE='$master_file', MASTER_LOG_POS=$master_pos"
mysql -h mysql-02-prod -e "START SLAVE;"


mysql -h mysql-04-prod -e "SET GLOBAL read_only = 'on';"
read master_file master_pos <<< $(mysql -h mysql-03-prod \
    -e "show master status" --batch --skip-column-names)
mysql -h mysql-04-prod -e "CHANGE MASTER TO MASTER_HOST='mysql-03-prod', \
    MASTER_PORT=3306, MASTER_USER='bronto', MASTER_PASSWORD='bronto', \
    MASTER_LOG_FILE='$master_file', MASTER_LOG_POS=$master_pos"
mysql -h mysql-04-prod -e "START SLAVE;"
