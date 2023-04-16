#!/bin/bash
set -o errexit
set -o nounset
#set -o xtrace
set -o pipefail

#sleep 5000


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

echo "dns_hetzner_api_token = $HETZNER_API_KEY" > /tmp/hetzner.ini

/script.sh > /proc/1/fd/1

# start cron
/usr/sbin/crond -f -l 8 