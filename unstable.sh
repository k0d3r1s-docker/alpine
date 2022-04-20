#!/bin/sh

cd ./source || exit
VERSION=`git rev-parse --short HEAD`

cd .. || exit

sudo ./alpine-make-rootfs --branch edge --timezone 'Europe/Riga' --script-chroot --packages 'apk-tools tzdata bash curl su-exec>=0.2 ca-certificates liburing liburing-dev' rootfs.tar.gz || exit

docker build --tag k0d3r1s/alpine:${VERSION} --tag k0d3r1s/alpine:unstable --squash --compress --no-cache -f Dockerfile . || exit

rm rootfs.tar.gz

old=`cat latest`
hub-tool tag rm k0d3r1s/alpine:$old -f
echo -n $VERSION > latest

docker push k0d3r1s/alpine:${VERSION}
docker push k0d3r1s/alpine:unstable