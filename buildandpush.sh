#!/usr/bin/env bash
set -o errexit
set -o nounset
#set -o xtrace
set -o pipefail

# Change Directory to script directory.
cd $(dirname "${BASH_SOURCE[0]}")

IMAGENAME="certbot-hetzner-stored-in-github"
TAGNAME="$(date +'%Y-%m-%d.%H-%M-%S.%N')" 
TAGNAME2="$(date +'%Y-%m-%d')" 

#linux/amd64,linux/arm64,linux/arm/v7
docker buildx build \
	--platform linux/amd64,linux/arm64,linux/arm/v7 \
	-t maskawanian/$IMAGENAME:$TAGNAME \
	-t maskawanian/$IMAGENAME:$TAGNAME2 \
	-t maskawanian/$IMAGENAME:latest \
	--no-cache \
	--push \
	.
	
docker pull --platform linux/arm64 maskawanian/$IMAGENAME:latest
#docker pull maskawanian/$IMAGENAME:latest
docker save maskawanian/$IMAGENAME:latest -o $IMAGENAME.tar


#docker image build --no-cache \
#	-t maskawanian/$IMAGENAME:$TAGNAME \
#	-t maskawanian/$IMAGENAME:$TAGNAME2 \
#	-t maskawanian/$IMAGENAME:latest \
#	.
#docker image push maskawanian/$IMAGENAME:$TAGNAME
#docker image push maskawanian/$IMAGENAME:$TAGNAME2
#docker image push maskawanian/$IMAGENAME:latest
