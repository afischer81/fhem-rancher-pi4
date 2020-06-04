#!/bin/bash

IMAGE=fhem/fhem:latest
FHEM_UID=6061
FHEM_GID=6061

function do_build {
    docker pull ${IMAGE}
}

function do_run {
    docker run \
        -d \
        -e LANG=en_US.UTF-8 \
        -e LANGUAGE=en_US:en \
        -e LC_ADDRESS=de_DE.UTF-8 \
        -e LC_MEASUREMENT=de_DE.UTF-8 \
        -e LC_MESSAGES=en_DK.UTF-8 \
        -e LC_MONETARY=de_DE.UTF-8 \
        -e LC_NAME=de_DE.UTF-8 \
        -e LC_NUMERIC=de_DE.UTF-8 \
        -e LC_PAPER=de_DE.UTF-8 \
        -e LC_TELEPHONE=de_DE.UTF-8 \
        -e LC_TIME=de_DE.UTF-8 \
        -e TZ=Europe/Berlin \
        -v /mnt/opt/fhem:/opt/fhem \
        --device=/dev/bus/usb/001/003 \
        --device=/dev/ttyACM0 \
        --hostname iobroker \
        --name fhem \
        --network=host \
        --restart unless-stopped \
        ${IMAGE}
}

function do_stop {
    docker rm -f fhem
}

function do_restart {
    do_stop
    sleep 5
    do_run
}

function do_install {
    if [ ! -f /mnt/opt/fhem ]
    then
        sudo mkdir /mnt/opt/fhem
        sudo addgroup -g ${FHEM_GID} fhem
        sudo adduser -G fhem -u ${FHEM_UID} -h /mnt/opt/fhem -s /bin/bash fhem
    fi
}

task=$1
shift
do_$task $*
