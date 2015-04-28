###
# BASICS
###


# Update
sudo apt-get -y update && apt-get -y upgrade

# SSH
sudo apt-get -y install openssh-server

# Build tools
sudo apt-get -y install build-essential automake libtool

# Utilities
sudo apt-get -y install git wget curl tree psmisc emacs24-nox vim ack-grep tmux screen
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

# vmfriendly ntpd replacement
sudo apt-get -y install chrony


# python and pip
sudo apt-get install -y python python-pip
sudo pip install -U pip

# Install Postgresql
sudo apt-get -y install postgresql

# Restart so that all new config is loaded:
sudo service postgresql restart

# bindfs to remount nfs shares
sudo apt-get install -y bindfs
