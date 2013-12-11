#!/usr/bin/env bash
vagrant suspececho ">>> Starting Install Script"

# Update
sudo apt-get update

# Install MySQL without prompt
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

echo ">>> Installing Base Items"

# Install base items
sudo apt-get install -y vim curl wget build-essential python-software-properties

    # echo ">>> Installing latest, greatest PHP"
    # sudo add-apt-repository -y ppa:ondrej/php5 # php5.5

     echo ">>> Installing PHP5.4"
    sudo add-apt-repository -y ppa:ondrej/php5-oldstable # php5.4

# Update Again
sudo apt-get update

# Installing extra php
sudo apt-get install -y php5 php5-mysql php5-curl php5-gd php5-mcrypt mysql-server

    # apache
    # echo ">>> Installing apache2"
    # sudo apt-get install -y apache2 libapache2-mod-php5
    # sudo a2enmod rewrite
    # sudo cp /vagrant/server/apache2.conf /etc/apache2/sites-available/000-default.conf
    # inifolder=/etc/php5/apache2

    # nginx
    echo ">>> Installing nginx"
    sudo service apache2 stop
    sudo apt-get purge apache2
    sudo apt-get install -y nginx php5-fpm
    sudo service nginx start
    sudo cp /vagrant/server/nginx.conf /etc/nginx/sites-available/default
    inifolder=/etc/php5/fpm

    echo $inifolder

# PHP Config
echo ">>> Configuring PHP"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" $inifolder/php.ini
sed -i "s/display_errors = .*/display_errors = On/" $inifolder/php.ini
sed -i "s/upload_max_filesize = .*/upload_max_filesize =20M/" $inifolder/php.ini
sed -i "s/post_max_size = .*/post_max_size = 20M/" $inifolder/php.ini

#sudo service apache2 restart
sudo service nginx restart

# Composer and GIT only needed for a "real" server
# echo ">>> Installing GIT and Composer"
# sudo apt-get install git
# curl -sS https://getcomposer.org/installer | php
# sudo mv composer.phar /usr/local/bin/composer