#!/bin/bash

set -e

OS_LIST="ubuntu debian centos fedore"

for OS_NAME in $OS_LIST
do
    docker build --build-arg FROM_IMAGE=${OS_NAME}  -f Dockerfile-${OS_NAME} -t ${OS_NAME}-with-systemd .
done

for OS_NAME in $OS_LIST
do
    docker run --privileged --name ${OS_NAME}-with-systemd -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro fanchthesystem/${OS_NAME}-with-systemd
done

for OS_NAME in $OS_LIST
do
    docker exec -it ${OS_NAME}-with-systemd systemctl status
done

for OS_NAME in $OS_LIST
do
    docker container stop ${OS_NAME}-with-systemd
done
