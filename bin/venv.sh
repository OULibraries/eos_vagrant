#!/bin/sh
virtualenv /srv/venv
. /srv/venv/bin/activate
pip install -r /srv/eos/etc/requirements.txt
deactivate
