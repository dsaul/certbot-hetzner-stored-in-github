#!/usr/bin/env bash
set -o errexit
set -o nounset
#set -o xtrace
set -o pipefail

if [ -z ${CERTIFICATE_DOMAIN+x} ];
	then echo "CERTIFICATE_DOMAIN is not set" && exit 1;
	else echo "CERTIFICATE_DOMAIN = '$CERTIFICATE_DOMAIN'";
fi

if [ -z ${EMAIL_ADDR+x} ];
	then echo "EMAIL_ADDR is not set" && exit 1;
	else echo "EMAIL_ADDR = '$EMAIL_ADDR'";
fi

if [ -z ${LINODE_API_KEY+x} ];
	then echo "LINODE_API_KEY is not set" && exit 1;
	else echo "LINODE_API_KEY = '$LINODE_API_KEY'";
fi

if [ -z ${GIT_URL+x} ];
	then echo "GIT_URL is not set" && exit 1;
	else echo "GIT_URL = '$GIT_URL'";
fi

if [ -z ${KEYPAIR_PRIVATE_FILE+x} ];
	then echo "KEYPAIR_PRIVATE_FILE is not set" && exit 1;
	else echo "KEYPAIR_PRIVATE_FILE = '$KEYPAIR_PRIVATE_FILE'";
fi

if [ -z ${KEYPAIR_PUBLIC_FILE+x} ];
	then echo "KEYPAIR_PUBLIC_FILE is not set" && exit 1;
	else echo "KEYPAIR_PUBLIC_FILE = '$KEYPAIR_PUBLIC_FILE'";
fi

echo "dns_linode_key = $LINODE_API_KEY" > /tmp/linode.ini

/script.sh > /proc/1/fd/1

# start cron
/usr/sbin/crond -f -l 8 