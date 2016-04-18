#!/bin/bash
virtualenv /srv/venv
. /srv/venv/bin/activate
pip install -r /srv/eos/etc/requirements.txt
deactivate
apt-get install -y libjpeg-dev # for pillow


# a python3 venv for Skripten
apt-get install -y python3-dev # lxml needs this
virtualenv /srv/skriptenv -p python3
. /srv/skriptenv/bin/activate
pip install lxml
deactivate
# and things it calls out to at runtime
apt-get install -y tralics texlive-xetex xzdec biber pdftk
cd /home/vagrant/
tlmgr init-usertree
tlmgr install l3kernel l3packages fontspec metalogo etoolbox makecmds xkeyval zhspacing unicode-math ucharcat filehook koma-script xifthen ifplatform ifmtarg braket mhchem l3experimental chemgreek here paralist footmisc float caption url mdwtools imakeidx setspace titlesec xcolor csquotes biblatex logreq xpatch
