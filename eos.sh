#!/bin/bash

# TODO: either remove vestiges of the old way, remove the new way, or combine both into a third way

# EOS Web stack
sudo apt-get install -y nginx-full libpcre3 libpcre3-dev libxml2-dev libxslt1-dev libpq-dev
#sudo pip install uwsgi virtualenv
sudo pip install virtualenv

## create virtual environment
sudo sh /vagrant/bin/venv.sh

# configure EOS location 
EOS_DIR=/srv/eos
mkdir -p $EOS_DIR

# create service account for eos
sudo useradd --system eosweb

# make legacy paths until we have time to clean them up
sudo mkdir /home/editionopenaccess/
sudo ln -s /srv/eos /home/editionopenaccess/eoa

git clone /vagrant/eoa-django/ ~vagrant/eoa-django
ln -s ~vagrant/eoa-django/eoa/website/ $EOS_DIR/
## Read useful values out of the config file
EOS_CFG=$EOS_DIR/website/website/settings.py                   # EOS Config File

EOS_DB_URL=` cat $EOS_CFG |  grep -A 10 'DATABASES = {' |  cut -d ":" -f 2 |  cut -d "=" -f 2 |  xargs`
HOSTNAME=`hostname`
EOS_DB=` echo $EOS_DB_URL |  cut -d "," -f 2 |  xargs`
EOS_USER=` echo $EOS_DB_URL |  cut -d "," -f 3 |  xargs`
EOS_PASS=` echo $EOS_DB_URL |  cut -d "," -f 4 |  xargs`
EOS_DB_HOST=` echo $EOS_DB_URL |  cut -d "," -f 5 |  xargs`
EOS_DB_PORT=` echo $EOS_DB_URL |  cut -d "," -f 6 |  xargs`

# Create the EOS user for the database
sudo -u postgres  cat <<EOF | sudo -u postgres psql
-- Create the database user:
CREATE USER $EOS_USER WITH PASSWORD '$EOS_PASS';
EOF

# Create the the EOS Web database
cp /vagrant/djangodb.psql $EOS_DIR/var/

sudo -u postgres createdb djangodb
sudo -u postgres psql djangodb  < $EOS_DIR/var/djangodb.psql

# # Give ownership to the EOS user
# sudo -u postgres  cat <<EOF | sudo -u postgres psql
# ALTER DATABASE $EOS_DB OWNER TO $EOS_USER;
# EOF


# wire up web app configuration 

#sudo rm  /etc/nginx/sites-enabled/default

#nginx config
#sudo ln -s /srv/eos/etc/website_nginx.conf /etc/nginx/sites-available/website_nginx.conf
#sudo ln -s /etc/nginx/sites-available/website_nginx.conf /etc/nginx/sites-enabled/website_nginx.conf

#uWSGI config
#sudo mkdir -p /etc/uwsgi/apps-available
#sudo mkdir /etc/uwsgi/apps-enabled
#sudo ln -s /srv/eos/etc/website_uwsgi.ini /etc/uwsgi/apps-available/website_uwsgi.ini
#sudo ln -s /etc/uwsgi/apps-available/website_uwsgi.ini /etc/uwsgi/apps-enabled/website_uwsgi.ini

# set up uWSGI with upstart
#sudo ln -s /srv/eos/etc/uwsgi.conf /etc/init/uwsgi.conf
#sudo initctl reload-configuration

# do ssl stuff
#SSLDIR=/etc/ssl/lib-26/
#sudo mkdir $SSLDIR
#sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSLDIR/key.key -out $SSLDIR/bundle.crt -days 3650 -subj /CN=eos.vm

# restart web servers
#sudo service nginx restart

cd ~vagrant
git clone /vagrant/EOASkripts/
pushd EOASkripts
git checkout vagrant
popd

source /srv/venv/bin/activate
cd ~vagrant/eoa-django/
pip install -r requirements.txt
cd eoa/website/
mkdir /home/user/
ln -s /home/vagrant/eoa-django/ /home/user/EOADjango

python manage.py syncdb --noinput
python manage.py migrate
nohup python manage.py runserver 0.0.0.0:8000 &
GUEST_IP="$(ifconfig eth1 | grep "inet addr" | sed "s/[^:]*://;s/ *Bcast.*//")"
echo "connect to http://$GUEST_IP:8000/index.html"
