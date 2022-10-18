#!/bin/bash

#########################################
#                                       #
# Author: Raad Orfali                   #
#                                       #
# Created on: 28/09/2022                #
#                                       #
# Modified on: 18/10/2022               #
#                                       #
#########################################

# Download and extract the update version
wget https://github.com/netbox-community/netbox/archive/v$1.tar.gz
tar -xzf v$1.tar.gz
rm v$1.tar.gz

# copy Config Files
cp /opt/netbox/local_requirements.txt /opt/netbox-$1
cp /opt/netbox/netbox/netbox/configuration.py /opt/netbox-$1/netbox/netbox/
cp /opt/netbox/netbox/netbox/ldap_config.py /opt/netbox-$1/netbox/netbox/

# copy the media files and modify permission
cp -pR /opt/netbox/netbox/media/ /opt/netbox-$1/netbox/
cd /opt/netbox/netbox
chown -R netbox:netbox media/

# copy the gunicorn file
cp /opt/netbox/gunicorn.py /opt/netbox-$1/

# create log folder and set the right permission
mkdir /opt/netbox-$1/logs
cp /opt/netbox/logs/django-ldap-debug.log /opt/netbox-$1/logs/
chown -R netbox:netbox /opt/netbox-$1/logs

# Switch to the new version
ln -sfn /opt/netbox-$1 /opt/netbox

# Run the upgrade script
cd /opt/netbox
./upgrade.sh

# Restart the Service
systemctl restart netbox netbox-rq

