#
# Aegir install script on Ubuntu 10.4 LTS server
# (install-aegir-on-ubuntu.sh)
#
# run as root (sudo su)
#
# todo:
#	add drush symlink
#	add better comments
#
# set some parameters: 
MYHOST="myhost.local"
MYIP="192.168.2.111"
AEGIR_PWD='wepoca'
#
# software requirements
#
apt-get install apache2 php5 php5-cli php5-gd php5-mysql mysql-server postfix rsync git-core unzip
#
# DNS Configuration
# admin.$MYHOST is the Aegir admin interface
echo $MYHOST > /etc/hostname
echo $MYIP $MYHOST admin.$MYHOST >> /etc/hosts
#
# Aegir user
adduser --system --group --home /var/aegir aegir
adduser aegir www-data
usermod -s /bin/bash -p $AEGIR_PWD aegir
#
#
# PHP Configuration
sed -i 's/memory_limit = -1/memory_limit = 192M/' /etc/php5/cli/php.ini
#
#
# Apache configuration
a2enmod rewrite
ln -s /var/aegir/config/apache.conf /etc/apache2/conf.d/aegir.conf
echo 'aegir ALL=NOPASSWD: /usr/sbin/apache2ctl' >> /etc/sudoers
#
#
# Database configuration
sed -i 's/bind-address/#bind-address/' /etc/mysql/my.cnf
/etc/init.d/mysql restart
#
#
# Aegir install script
wget -O install.sh 'http://git.aegirproject.org/?p=provision.git;a=blob_plain;f=install.sh.txt;hb=provision-0.4-beta2'
su -s /bin/sh aegir -c "sh install.sh"
#
#
# Checkpoint / Finished!
# The installation will provide you with a one-time login URL to stdout or via an e-mail.
# Use this link to login to your new Aegir site for the first time.
