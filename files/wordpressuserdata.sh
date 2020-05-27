#!/bin/bash
sudo echo "127.0.0.1 `hostname`" >> /etc/hosts
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd
systemctl start httpd
systemctl enable httpd
yum install -y php-cli php-pdo php-fpm php-json php-mysqlnd
wget -c http://wordpress.org/wordpress-5.4.1.tar.gz
tar -xzvf wordpress-5.4.1.tar.gz
sleep 20
mkdir -p /var/www/html/
rsync -av wordpress/* /var/www/html/
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
sed -i 's/database_name_here/wordpress_db/g' /var/www/html/wp-config.php
sed -i 's/username_here/wordpress/g' /var/www/html/wp-config.php
sed -i 's/password_here/sc@R88yutet1/g' /var/www/html/wp-config.php
sed -i 's/localhost/${DB_HOST}/g' /var/www/html/wp-config.php
systemctl restart httpd
sleep 20
