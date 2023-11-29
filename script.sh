#!/bin/bash
set -o errexit
set -o nounset
#set -o xtrace
set -o pipefail

if [ -z ${CERTIFICATE_DOMAIN+x} ]; then
	 echo "CERTIFICATE_DOMAIN is not set" && exit 1;
else 
	echo "CERTIFICATE_DOMAIN = '$CERTIFICATE_DOMAIN'";
fi

if [ -z ${EMAIL_ADDR+x} ]; then
	echo "EMAIL_ADDR is not set" && exit 1;
else 
	echo "EMAIL_ADDR = '$EMAIL_ADDR'";
fi

if [ -z ${HETZNER_API_KEY+x} ]; then
	echo "HETZNER_API_KEY is not set" && exit 1;
else 
	echo "HETZNER_API_KEY = '$HETZNER_API_KEY'";
fi

if [ -z ${GIT_URL+x} ]; then
	echo "GIT_URL is not set" && exit 1;
else 
	echo "GIT_URL = '$GIT_URL'";
fi

if [ -z ${KEYPAIR_PRIVATE_FILE+x} ] && [ -z ${KEYPAIR_PRIVATE_BASE64+x} ]; then
	echo "KEYPAIR_PRIVATE_FILE and KEYPAIR_PRIVATE_BASE64 is not set" && exit 1;
fi
if [ ${KEYPAIR_PRIVATE_FILE+x} ]; then
	echo "KEYPAIR_PRIVATE_FILE = '${KEYPAIR_PRIVATE_FILE+x}'";
fi

# Make sure we have the secret files in position.
rm /root/.ssh/* || true

if [ ${KEYPAIR_PRIVATE_FILE+x} ]; then
	cp $KEYPAIR_PRIVATE_FILE /root/.ssh/KEYPAIR_PRIVATE
elif [ ${KEYPAIR_PRIVATE_BASE64+x} ]; then
	echo "$KEYPAIR_PRIVATE_BASE64" | base64 -d > /root/.ssh/KEYPAIR_PRIVATE
	echo "wrote /root/.ssh/KEYPAIR_PRIVATE"
	#sleep 5000
else 
	echo "Not able to create /root/.ssh/KEYPAIR_PRIVATE" && exit 1;
fi

ssh-keyscan github.com >> /root/.ssh/known_hosts

# Correct ssh permissions
chmod go-w /root/ || true
chmod 700 /root/.ssh || true
chmod 600 /root/.ssh/KEYPAIR_PRIVATE || true
chmod 600 /tmp/hetzner.ini || true

# Clear our the lets encrypt directory.
mkdir -p /etc/letsencrypt
rm -rfv /etc/letsencrypt/* || true
rm -rfv /etc/letsencrypt/.git || true

# Add git credentials.
git config --global user.email "certbot-hetzner-stored-in-github@example.com"
git config --global user.name "Docker Container"




ssh-agent bash -c "ssh-add /root/.ssh/KEYPAIR_PRIVATE; git clone --depth 1 $GIT_URL -b master /etc/letsencrypt" 


certbot -v \
	certonly \
	--authenticator dns-hetzner \
	--dns-hetzner-credentials /tmp/hetzner.ini \
	-d $CERTIFICATE_DOMAIN \
	-d *.$CERTIFICATE_DOMAIN \
	--agree-tos \
	--no-eff-email \
	--preferred-challenges dns-01 \
	--non-interactive \
	-m $EMAIL_ADDR \
	--server https://acme-v02.api.letsencrypt.org/directory || cat /var/log/letsencrypt/letsencrypt.log
	

cd /etc/letsencrypt
git add -v * || echo "git was unable to add"
git commit -v -m "Update Container Changes @ $(date -u +"%Y-%m-%dT%H:%M:%SZ") " || echo "git was unable to commit"

ssh-agent bash -c 'ssh-add /root/.ssh/KEYPAIR_PRIVATE; git push origin master || echo "git was unable to push"'




