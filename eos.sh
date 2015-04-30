
# EOS Web stack
sudo apt-get install -y nginx-full libpcre3 libpcre3-dev libxml2-dev libxslt1-dev libpq-dev
sudo pip install uwsgi virtualenv


# configure EOS location 
EOS_DIR=/srv/eos

# create service account for eos
sudo useradd --system eosweb

# make legacy paths until we have time to clean them up
sudo mkdir /home/editionopenaccess/
sudo ln -s /srv/eos /home/editionopenaccess/eoa

## Read useful values out of the config file
EOS_CFG=$EOS_DIR/website/website/settings.py                   # EOS Config File

EOS_DB_URL=` cat $EOS_CFG |  grep -A 10 'DATABASES = {' |  cut -d ":" -f 2 |  cut -d "=" -f 2 |  xargs`
HOSTNAME=`hostname`
EOS_DB=` echo $EOS_DB_URL |  cut -d "," -f 2 |  xargs`
EOS_USER=` echo $EOS_DB_URL |  cut -d "," -f 3 |  xargs`
EOS_PASS=` echo $EOS_DB_URL |  cut -d "," -f 4 |  xargs`
EOS_DB_HOST=` echo $EOS_DB_URL |  cut -d "," -f 5 |  xargs`
EOS_DB_PORT=` echo $EOS_DB_URL |  cut -d "," -f 6 |  xargs`


# update uwsgi start script 
sudo sed --in-place  's|DAEMON="/usr/bin/uwsgi"|DAEMON="/usr/local/bin/uwsgi"|' /etc/init.d/uwsgi

# Create the EOS user
sudo -u postgres  cat <<EOF | sudo -u postgres psql
-- Create the database user:
CREATE USER $EOS_USER WITH PASSWORD '$EOS_PASS';
EOF

# Create the the EOS Web database
sudo -u postgres pg_restore -C -d postgres  $EOS_DIR/djangodb.psql

# # Give ownership to the EOS user
# sudo -u postgres  cat <<EOF | sudo -u postgres psql
# ALTER DATABASE $EOS_DB OWNER TO $EOS_USER;
# EOF


# wire up web app configuration 

sudo rm  /etc/nginx/sites-enabled/default

#nginx config
sudo ln -s /srv/eos/etc/website_nginx.conf /etc/nginx/sites-available/website_nginx.conf
sudo ln -s /etc/nginx/sites-available/website_nginx.conf /etc/nginx/sites-enabled/website_nginx.conf

#uWSGI config
sudo mkdir -p /etc/uwsgi/apps-available
sudo mkdir /etc/uwsgi/apps-enabled
sudo ln -s /srv/eos/etc/website_uwsgi.ini /etc/uwsgi/apps-available/website_uwsgi.ini
sudo ln -s /etc/uwsgi/apps-available/website_uwsgi.ini /etc/uwsgi/apps-enabled/website_uwsgi.ini

# set up uWSGI with upstart
sudo ln -s /srv/eos/etc/uwsgi.conf /etc/init/uwsgi.conf
sudo initctl reload-configuration

# do ssl stuff
SSLDIR=/etc/ssl/lib-26/
sudo mkdir $SSLDIR
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $SSLDIR/key.key -out $SSLDIR/bundle.crt -days 3650 -subj /CN=eos.vm

# restart web servers
sudo service nginx restart
sudo service uwsgi restart

