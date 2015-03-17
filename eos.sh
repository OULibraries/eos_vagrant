
# configure EOS location 
EOS_DIR=/srv/eos

# create service account for eos
sudo useradd --system eosweb 

## Read useful values out of the config file
EOS_CFG=$EOS_DIR/website/website/settings.py                   # EOS Config File

EOS_DB_URL=` cat $EOS_CFG |  grep -A 10 'DATABASES = {' |  cut -d ":" -f 2 |  cut -d "=" -f 2 |  xargs`
HOSTNAME=`hostname`
EOS_DB=` echo $EOS_DB_URL |  cut -d "," -f 2 |  xargs`
EOS_USER=` echo $EOS_DB_URL |  cut -d "," -f 3 |  xargs`
EOS_PASS=` echo $EOS_DB_URL |  cut -d "," -f 4 |  xargs`
EOS_DB_HOST=` echo $EOS_DB_URL |  cut -d "," -f 5 |  xargs`
EOS_DB_PORT=` echo $EOS_DB_URL |  cut -d "," -f 6 |  xargs`


# Create the EOS user
sudo -u postgres  cat <<EOF | sudo -u postgres psql
-- Create the database user:
CREATE USER $EOS_USER WITH PASSWORD '$EOS_PASS';
EOF

# Create the the EOS Web database
sudo -u postgres pg_restore -Fc -C -d postgres  $EOS_DIR/djangodb.psql

# # Create and give ownership to the EOS user
# sudo -u postgres  cat <<EOF | sudo -u postgres psql
# -- Create the database user:
# CREATE USER $EOS_USER WITH PASSWORD '$EOS_PASS';
# ALTER DATABASE $EOS_DB OWNER TO $EOS_USER;
# EOF



