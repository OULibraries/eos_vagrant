#!/bin/sh
virtualenv /srv/venv
source /srv/venv/bin/activate
pip install -r /srv/eos/etc/requirements.txt
deactivate
