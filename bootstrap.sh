DBPASS="toor"

# Update Packages
apt-get update
# Upgrade Packages
apt-get upgrade

# Basic Linux Stuff
apt-get install -y git

# Apache
apt-get install -y apache2

# Enable Apache Mods
a2enmod rewrite

#Add Onrej PPA Repo
apt-add-repository ppa:ondrej/php
apt-get update

# Install PHP
apt-get install -y php7.2

# PHP Apache Mod
apt-get install -y libapache2-mod-php7.2

# Restart Apache
service apache2 restart

# PHP Mods
apt-get install -y php7.2-common
apt-get install -y php7.2-mcrypt
apt-get install -y php7.2-zip

sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/apache2/php.ini

echo -e "\n--- Installing Composer for PHP package management ---\n"
curl --silent https://getcomposer.org/installer | php >> /vagrant/vm_build.log 2>&1
mv composer.phar /usr/local/bin/composer

# Set MySQL Pass
debconf-set-selections <<< "mysql-server mysql-server/root_password password $DBPASS"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DBPASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $DBPASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASS"
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none"

# Install MySQL
echo -e "\n--- Installing SQL ---\n"
apt-get install -y mysql-server

# PHP-MYSQL lib
apt-get install -y php7.2-mysql

# Install phpmyadmin
echo -e "\n--- Installing phpMyAdmin ---\n"
apt-get install  -y phpmyadmin

# Restart Apache
sudo service apache2 restart