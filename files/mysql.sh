#!/bin/bash
##### My Sql Installation Files####
wget https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum localinstall -y mysql57-community-release-el7-11.noarch.rpm 
yum install -y mysql-community-server
systemctl start mysqld.service
my_password=$(cat /var/log/mysqld.log | grep "A temporary password is generated for" | tail -1 | sed -n 's/.*root@localhost: //p')
newPassword="wh@teverYouLik3"
# resetting temporary password
mysql --connect-expired-password -uroot -p"$${my_password}" -Bse "ALTER USER 'root'@'localhost' IDENTIFIED BY '$newPassword';"

mysql -u root -p"$${newPassword}" -e "create user 'wordpress'@'%' identified by 'sc@R88yutet1';"
mysql -u root -p"$${newPassword}" -e "create database wordpress_db"
mysql -u root -p"$${newPassword}" -e "grant all privileges on wordpress_db.* to 'wordpress'@'%' identified by 'sc@R88yutet1'"
